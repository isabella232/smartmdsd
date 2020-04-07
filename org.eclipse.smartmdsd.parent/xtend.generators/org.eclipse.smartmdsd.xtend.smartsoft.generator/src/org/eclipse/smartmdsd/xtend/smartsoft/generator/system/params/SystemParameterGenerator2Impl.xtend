/********************************************************************************
 * Copyright (c) 2018 Technische Hochschule Ulm, Servicerobotics Ulm, Germany
 * 
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License v. 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 * 
 * SPDX-License-Identifier: EPL-2.0
 * 
 * Contributors:
 *   Alex Lotz, Matthias Lutz, Dennis Stampfer
 ********************************************************************************/
package org.eclipse.smartmdsd.xtend.smartsoft.generator.system.params

import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import org.eclipse.smartmdsd.ecore.system.systemParameter.SystemParamModel
import org.eclipse.smartmdsd.xtend.smartsoft.generator.ExtendedOutputConfigurationProvider
import org.eclipse.smartmdsd.ecore.system.systemParameter.ComponentParameterInstance
import com.google.inject.Inject
import org.eclipse.smartmdsd.xtend.smartsoft.generator.component.params.SmartComponentParameter
import org.eclipse.smartmdsd.ecore.system.systemParameter.ParameterRefinement
import org.eclipse.smartmdsd.ecore.component.componentParameter.ParameterInstance
import org.eclipse.smartmdsd.ecore.component.componentParameter.ComponentParameterBase
import org.eclipse.smartmdsd.ecore.component.componentParameter.ExtendedParameter
import org.eclipse.smartmdsd.ecore.component.componentParameter.InternalParameter
import org.eclipse.smartmdsd.ecore.component.componentParameter.ComponentParametersRef

class SystemParameterGenerator2Impl extends AbstractGenerator {
	
	@Inject extension SmartComponentParameter
	
	override doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		for(model: resource.allContents.toIterable.filter(typeof(SystemParamModel))) {
			for(instance: model.system.components) {
				val systemParam = model.components.findFirst[it.componentInstance==instance]
				if(systemParam!==null) {
					// use the refined system parameters for ini-file generation
					fsa.generateFile(
						systemParam.name+".ini",
						ExtendedOutputConfigurationProvider.SRC_GEN_PARAMS,
						systemParam.compile
					);
				} else {
					// no system parameter refinement defined -> try getting the default component parameters
					val componentParams = instance.component.elements.filter(ComponentParametersRef).head
					if(componentParams !== null) {
						// generate the default component parameters
						fsa.generateFile(
							instance.name+".ini",
							ExtendedOutputConfigurationProvider.SRC_GEN_PARAMS,
							componentParams.parameter.compileIniFile
						)
					}
				}
			}
		}
	}
	
	
	def compile(ComponentParameterInstance parameterInstance)
	'''
	##########################
	## component parameters ##
	##########################
	
	«FOR parameter: parameterInstance.componentParam.eAllContents.toIterable.filter(ComponentParameterBase)»
		«IF parameterInstance.parameters.exists[it.parameter==parameter]»
			«parameterInstance.parameters.findFirst[it.parameter==parameter].compileParameterRefinement»
		«ELSE»
			«parameter.compileIniFileParameter»
		«ENDIF»
	«ENDFOR»
	'''
	
	def compileParameterRefinement(ParameterRefinement refinement)
	'''
		######################################
		## parameter refinement «refinement.name»
		[«refinement.name»]
		«val parameter = refinement.parameter»
		«IF parameter instanceof ParameterInstance»
			«FOR attr: parameter.attributes»
				«IF refinement.attributes.exists[it.attribute.name==attr.attribute.name]»
					«refinement.attributes.findFirst[it.attribute.name==attr.attribute.name].compileIniAttribute»
				«ELSE»
					«attr.compileIniAttribute»
				«ENDIF»
			«ENDFOR»
		«ELSEIF parameter instanceof InternalParameter»
			«FOR attr: parameter.attributes»
				«IF refinement.attributes.exists[it.attribute.name==attr.name]»
					«refinement.attributes.findFirst[it.attribute.name==attr.name].compileIniAttribute»
				«ELSE»
					«attr.compileIniAttribute»
				«ENDIF»
			«ENDFOR»
		«ELSEIF parameter instanceof ExtendedParameter»
			«FOR attr: parameter.attributes»
				«IF refinement.attributes.exists[it.attribute.name==attr.name]»
					«refinement.attributes.findFirst[it.attribute.name==attr.name].compileIniAttribute»
				«ELSE»
					«attr.compileIniAttribute»
				«ENDIF»
			«ENDFOR»
		«ENDIF»
	''' 
	
	def private getName(ParameterRefinement refinement) {
		val parameter = refinement.parameter
		switch(parameter) {
			ExtendedParameter: parameter.name
			InternalParameter: parameter.name
			ParameterInstance: parameter.name
		}
	}
}