/********************************************************************************
 * Copyright (c) 2019 Technische Hochschule Ulm, Servicerobotics Ulm, Germany
 * headed by Prof. Dr. Christian Schlegel
 * 
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License v. 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 * 
 * SPDX-License-Identifier: EPL-2.0
 * 
 * Contributors:
 *   Matthias Lutz, Alex Lotz, Dennis Stampfer
 ********************************************************************************/
package org.eclipse.smartmdsd.xtext.behavior.taskDefinition.ide

import com.google.inject.Guice
import org.eclipse.smartmdsd.xtext.behavior.taskDefinition.TaskDefinitionRuntimeModule
import org.eclipse.smartmdsd.xtext.behavior.taskDefinition.TaskDefinitionStandaloneSetup
import org.eclipse.xtext.util.Modules2

/**
 * Initialization support for running Xtext languages as language servers.
 */
class TaskDefinitionIdeSetup extends TaskDefinitionStandaloneSetup {

	override createInjector() {
		Guice.createInjector(Modules2.mixin(new TaskDefinitionRuntimeModule, new TaskDefinitionIdeModule))
	}
	
}
