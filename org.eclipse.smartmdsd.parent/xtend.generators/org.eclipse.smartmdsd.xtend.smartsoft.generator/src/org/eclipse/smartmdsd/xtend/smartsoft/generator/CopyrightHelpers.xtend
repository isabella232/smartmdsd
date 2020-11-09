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
 *   Alex Lotz, Matthias Lutz, Dennis Stampfer
 ********************************************************************************/
package org.eclipse.smartmdsd.xtend.smartsoft.generator

import org.eclipse.core.runtime.Platform

class CopyrightHelpers {
	
	def private String getVersion() {
		return Platform.getBundle("org.eclipse.smartmdsd.xtend.smartsoft.generator").version.toString
	}
	
	def String getToolchainVersionFileString()
	'''
	«copyright»
	
	// Generated with SmartMDSD Toolchain Version «version»
	'''
	
	
	def String copyrightHelper() '''
		//--------------------------------------------------------------------------
		// Code generated by the SmartSoft MDSD Toolchain
		// The SmartSoft Toolchain has been developed by:
		//  
		// Service Robotics Research Center
		// University of Applied Sciences Ulm
		// Prittwitzstr. 10
		// 89075 Ulm (Germany)
		//
		// Information about the SmartSoft MDSD Toolchain is available at:
		// www.servicerobotik-ulm.de
		//
	'''

	// returns copyright for source files
	def String getCopyright() '''
		«copyrightHelper()»
		// Please do not modify this file. It will be re-generated
		// running the code generator.
		//--------------------------------------------------------------------------
	'''

	// returns copyright for source files which are generated once
	def String getCopyrightWriteOnce() '''
		«copyrightHelper()» 
		// This file is generated once. Modify this file to your needs. 
		// If you want the toolchain to re-generate this file, please 
		// delete it before running the code generator.
		//--------------------------------------------------------------------------
	'''
	
	
	// returns copyright for files which need #
	def String getCopyrightHash() {
		return getCopyright().replaceAll("//","#");
	}
	
	
	// returns copyright for files which need # and are generated once
	def String getCopyrightWriteOnceHash() {
		getCopyrightWriteOnce().replaceAll("//","#");
	}
}