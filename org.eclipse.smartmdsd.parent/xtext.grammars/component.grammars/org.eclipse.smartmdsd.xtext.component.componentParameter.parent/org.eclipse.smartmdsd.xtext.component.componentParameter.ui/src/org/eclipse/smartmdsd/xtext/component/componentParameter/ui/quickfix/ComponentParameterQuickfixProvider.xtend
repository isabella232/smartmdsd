/********************************************************************************
 * Copyright (c) 2017 Technische Hochschule Ulm, Servicerobotics Ulm, Germany
 * headed by Prof. Dr. Christian Schlegel
 * 
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License v. 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 * 
 * SPDX-License-Identifier: EPL-2.0
 * 
 * Contributors:
 *   Alex Lotz, Dennis Stampfer, Matthias Lutz
 ********************************************************************************/
package org.eclipse.smartmdsd.xtext.component.componentParameter.ui.quickfix

import org.eclipse.smartmdsd.xtext.service.parameterDefinition.ui.quickfix.ParameterDefinitionQuickfixProvider
import org.eclipse.smartmdsd.xtext.component.componentParameter.validation.ComponentParameterValidator
import org.eclipse.xtext.ui.editor.quickfix.Fix
import org.eclipse.xtext.ui.editor.quickfix.IssueResolutionAcceptor
import org.eclipse.xtext.validation.Issue
import org.eclipse.smartmdsd.ecore.component.componentParameter.ParameterInstance
import com.google.inject.Inject
import org.eclipse.smartmdsd.ecore.component.componentParameter.ComponentParameterTypeConformance
import org.eclipse.ui.PlatformUI
import org.eclipse.xtext.ui.editor.XtextEditor
import org.eclipse.jface.text.source.SourceViewer
import org.eclipse.jface.text.source.ISourceViewer
import org.eclipse.smartmdsd.ecore.component.componentParameter.ComponentParameter
import org.eclipse.smartmdsd.ecore.base.basicAttributes.BasicAttributesFactory
import org.eclipse.smartmdsd.ecore.base.basicAttributes.BasicAttributesModelUtility
import org.eclipse.smartmdsd.ecore.base.basicAttributes.AttributeDefinition

/**
 * Custom quickfixes.
 *
 * See https://www.eclipse.org/Xtext/documentation/310_eclipse_support.html#quick-fixes
 */
class ComponentParameterQuickfixProvider extends ParameterDefinitionQuickfixProvider {

	@Inject ComponentParameterTypeConformance conf;
	@Inject BasicAttributesModelUtility util;

	@Fix(ComponentParameterValidator.MISSING_ATTRIBUTE_REFINEMENTS)
	def addMissingAttributeRefinements(Issue issue, IssueResolutionAcceptor acceptor) {
		acceptor.accept(issue, 'Add missing attribute-refinements', 'Add missing attribute-refinements.', '') [
			element, context |
			val param = (element as ParameterInstance)
			param.parameterDef.attributes.forEach[
				attribute |
				if(!param.attributes.exists[ref|ref.attribute.equals(attribute)]) {
					val attrRef = BasicAttributesFactory.eINSTANCE.createAttributeRefinement
					attrRef.attribute = attribute
					if(attribute.defaultvalue !== null) {
						attrRef.value = attribute.defaultvalue
					} else {
						attrRef.value = conf.createPrimitiveDefaultValue(attribute.type)
					}
					param.attributes.add(attrRef)
				}
			]
		]
		val editor = PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage().getActiveEditor();
		if(editor instanceof XtextEditor) {
			(editor.internalSourceViewer as SourceViewer).doOperation(ISourceViewer.FORMAT)
		}
	}
	
	@Fix(ComponentParameterValidator.SINGLE_PARAM_SET_INSTANCE)
	def fixMultipleParamSetInstances(Issue issue, IssueResolutionAcceptor acceptor) {
		acceptor.accept(issue, 'Remove ParameterSetInstance', 
			'Remove ParameterSetInstance "'+issue.data.get(0)+'".', 
			'') 
			[
				element, context |
				val param = element.eContainer as ComponentParameter
				param.parameters.remove(element)
			]
	}
	
	@Fix(ComponentParameterValidator.PARAM_SET_INSTANCE_MATCH_BEHAVIOR_INTERFACE)
	def fixParameterSetInstanceMatchComponentBehaviorSlaveInterface(Issue issue, IssueResolutionAcceptor acceptor) {
		acceptor.accept(issue, 'Change ParameterSetInstance to "'+issue.data.get(0)+'".', 
			'Change ParameterSetInstance to "'+issue.data.get(0)+'".', 
			'') 
			[
				context |
				val doc = context.xtextDocument
				doc.replace(issue.offset, issue.length, issue.data.get(0))
			]
	}
	
	@Fix(ComponentParameterValidator.MISSING_ATTRIBUTE_VALUE)
	def fixMisingAttributeValue(Issue issue, IssueResolutionAcceptor acceptor) {
		acceptor.accept(issue, 'Add default attribute value', 
			'Add default attribute value', 
			'') 
			[
				element, context |
				val doc = context.xtextDocument
				val attr = element as AttributeDefinition
				doc.replace(issue.offset+issue.length, 1, " = "+util.getDefaultValuesFor(attr.type).get(0)+"\n")
			]
	}
}
