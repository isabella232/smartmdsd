/********************************************************************************
 * Copyright (c) 2017 Technische Hochschule Ulm, Servicerobotics Ulm, Germany
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
package org.eclipse.smartmdsd.xtext.base.stateMachine.ide

import com.google.inject.Guice
import org.eclipse.smartmdsd.xtext.base.stateMachine.StateMachineRuntimeModule
import org.eclipse.smartmdsd.xtext.base.stateMachine.StateMachineStandaloneSetup
import org.eclipse.xtext.util.Modules2

/**
 * Initialization support for running Xtext languages as language servers.
 */
class StateMachineIdeSetup extends StateMachineStandaloneSetup {

	override createInjector() {
		Guice.createInjector(Modules2.mixin(new StateMachineRuntimeModule, new StateMachineIdeModule))
	}
	
}
