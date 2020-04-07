/**
 * Copyright (c) 2019 Technische Hochschule Ulm, Servicerobotics Ulm, Germany
 * 
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License v. 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *  
 * SPDX-License-Identifier: EPL-2.0
 *  
 * Contributors:
 *    Matthias Lutz, Alex Lotz, Dennis Stampfer
 */
package org.eclipse.smartmdsd.ecore.system.compArchBehaviorExtension.provider;

import org.eclipse.emf.common.EMFPlugin;

import org.eclipse.emf.common.util.ResourceLocator;

import org.eclipse.smartmdsd.ecore.base.basicAttributes.provider.BasicAttributesEditPlugin;

import org.eclipse.smartmdsd.ecore.base.documentation.provider.DocumentationEditPlugin;

import org.eclipse.smartmdsd.ecore.base.stateMachine.provider.StateMachineEditPlugin;

import org.eclipse.smartmdsd.ecore.behavior.skillRealization.provider.SkillRealizationEditPlugin;

import org.eclipse.smartmdsd.ecore.behavior.taskDefinition.provider.TaskDefinitionEditPlugin;

import org.eclipse.smartmdsd.ecore.behavior.taskRealization.provider.TaskRealizationEditPlugin;

import org.eclipse.smartmdsd.ecore.component.componentDefinition.provider.ComponentDefinitionEditPlugin;

import org.eclipse.smartmdsd.ecore.service.communicationObject.provider.CommunicationObjectEditPlugin;

import org.eclipse.smartmdsd.ecore.service.communicationPattern.provider.CommunicationPatternEditPlugin;

import org.eclipse.smartmdsd.ecore.service.componentMode.provider.ComponentModeEditPlugin;

import org.eclipse.smartmdsd.ecore.service.coordinationPattern.provider.CoordinationPatternEditPlugin;

import org.eclipse.smartmdsd.ecore.service.parameterDefinition.provider.ParameterDefinitionEditPlugin;

import org.eclipse.smartmdsd.ecore.service.roboticMiddleware.provider.RoboticMiddlewareEditPlugin;

import org.eclipse.smartmdsd.ecore.service.serviceDefinition.provider.ServiceDefinitionEditPlugin;

import org.eclipse.smartmdsd.ecore.service.skillDefinition.provider.SkillDefinitionEditPlugin;

import org.eclipse.smartmdsd.ecore.system.activityArchitecture.provider.ActivityArchitectureEditPlugin;

import org.eclipse.smartmdsd.ecore.system.componentArchitecture.provider.ComponentArchitectureEditPlugin;

/**
 * This is the central singleton for the CompArchBehaviorExtension edit plugin.
 * <!-- begin-user-doc -->
 * <!-- end-user-doc -->
 * @generated
 */
public final class CompArchBehaviorExtensionEditPlugin extends EMFPlugin {
	/**
	 * Keep track of the singleton.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public static final CompArchBehaviorExtensionEditPlugin INSTANCE = new CompArchBehaviorExtensionEditPlugin();

	/**
	 * Keep track of the singleton.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	private static Implementation plugin;

	/**
	 * Create the instance.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public CompArchBehaviorExtensionEditPlugin() {
		super(new ResourceLocator[] { ActivityArchitectureEditPlugin.INSTANCE, BasicAttributesEditPlugin.INSTANCE,
				CommunicationObjectEditPlugin.INSTANCE, CommunicationPatternEditPlugin.INSTANCE,
				ComponentArchitectureEditPlugin.INSTANCE, ComponentDefinitionEditPlugin.INSTANCE,
				ComponentModeEditPlugin.INSTANCE, CoordinationPatternEditPlugin.INSTANCE,
				DocumentationEditPlugin.INSTANCE, ParameterDefinitionEditPlugin.INSTANCE,
				RoboticMiddlewareEditPlugin.INSTANCE, ServiceDefinitionEditPlugin.INSTANCE,
				SkillDefinitionEditPlugin.INSTANCE, SkillRealizationEditPlugin.INSTANCE,
				StateMachineEditPlugin.INSTANCE, TaskDefinitionEditPlugin.INSTANCE,
				TaskRealizationEditPlugin.INSTANCE, });
	}

	/**
	 * Returns the singleton instance of the Eclipse plugin.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the singleton instance.
	 * @generated
	 */
	@Override
	public ResourceLocator getPluginResourceLocator() {
		return plugin;
	}

	/**
	 * Returns the singleton instance of the Eclipse plugin.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the singleton instance.
	 * @generated
	 */
	public static Implementation getPlugin() {
		return plugin;
	}

	/**
	 * The actual implementation of the Eclipse <b>Plugin</b>.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public static class Implementation extends EclipsePlugin {
		/**
		 * Creates an instance.
		 * <!-- begin-user-doc -->
		 * <!-- end-user-doc -->
		 * @generated
		 */
		public Implementation() {
			super();

			// Remember the static instance.
			//
			plugin = this;
		}
	}

}
