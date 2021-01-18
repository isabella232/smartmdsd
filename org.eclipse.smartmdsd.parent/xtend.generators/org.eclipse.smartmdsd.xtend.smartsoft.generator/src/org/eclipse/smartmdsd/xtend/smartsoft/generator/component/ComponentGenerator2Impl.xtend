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
package org.eclipse.smartmdsd.xtend.smartsoft.generator.component

import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import org.eclipse.smartmdsd.xtend.smartsoft.generator.ExtendedOutputConfigurationProvider
import com.google.inject.Inject
import org.eclipse.smartmdsd.xtend.smartsoft.generator.CopyrightHelpers
import org.eclipse.smartmdsd.ecore.component.componentDefinition.ComponentDefinition
import static extension org.eclipse.smartmdsd.ecore.component.componentDefinition.ComponentDefinitionModelUtility.*
import org.eclipse.smartmdsd.ecore.component.componentParameter.ComponentParametersRef
import org.eclipse.smartmdsd.xtend.smartsoft.generator.component.params.ComponentParamsGenerator2
import org.eclipse.smartmdsd.ecore.component.componentDefinition.ComponentSubNode

class ComponentGenerator2Impl extends AbstractGenerator {
	@Inject extension SmartComponent
	@Inject extension ComponentCMakeGenerator
	@Inject extension CopyrightHelpers
	@Inject extension SmartTask
	@Inject extension SmartHandlerState
	@Inject extension SmartIniParameter
	@Inject extension SmartEventHandler
	@Inject extension SmartInputHandler
	@Inject extension SmartQueryHandler
	@Inject extension InteractionObserver
	
	@Inject extension SmartComponentPortFactory
	@Inject extension SmartComponentExtension
	
	@Inject ComponentParamsGenerator2 paramGenerator;
	
	override doGenerate(Resource input, IFileSystemAccess2 fsa, IGeneratorContext context) {
		for(comp: input.allContents.toIterable.filter(typeof(ComponentDefinition))) {
			// info file with generator version string
			fsa.generateFile("info.txt", comp.compileToolchainVersionFile);
			
			for(param: comp.elements.filter(ComponentParametersRef)) {
				// generate parameters
				paramGenerator.doGenerate(param.parameter.eResource, fsa, context)
			}
			
			// generate ini file
			val iniFileHeadContent = comp.CreateIniFile
			fsa.generateFile(comp.parameterIniFileName, iniFileHeadContent)
			
			val bottominiFileName = comp.name+".ini.bottom"
			if(fsa.isFile(bottominiFileName, ExtendedOutputConfigurationProvider::SRC_GEN_PARAMS)) {
				val iniFileBottomContent = fsa.readTextFile(bottominiFileName, ExtendedOutputConfigurationProvider::SRC_GEN_PARAMS).toString
				fsa.generateFile(comp.name+".ini.template", iniFileHeadContent+iniFileBottomContent)				
			}
			
			// generate main.cc
			fsa.generateFile("main.cc", comp.MainFileContent);

			// generate factory classes for creating different kinds of Ports
			fsa.generateFile(comp.portFactoryInterfaceFilename, comp.compilePortFactoryInterface)
			fsa.generateFile(comp.acePortFactoryHeaderFilename, comp.compileAcePortFactoryHeader)
			fsa.generateFile(comp.acePortFactorySourceFilename, comp.compileAcePortFactorySource)
			
			// generate a ComponentExtension base class
			fsa.generateFile(comp.componentExtensionHeaderFilename, comp.compileComponentExtensionHeader)
			fsa.generateFile(comp.componentExtensionSourceFilename, comp.compileComponentExtensionSource)
			
			// Generate SmartComponent
			fsa.generateFile(comp.getCompImplHeaderFilename, comp.CompImplHeaderFileContent);
			fsa.generateFile(comp.getCompImplSourceFilename, comp.CompImplSourceFileContent);
			fsa.generateFile(comp.getCompHeaderFilename, comp.CompHeaderFileContent);
			fsa.generateFile(comp.getCompSourceFilename, comp.CompSourceFileContent);
			fsa.generateFile(comp.getCoreUserHeaderFilename, ExtendedOutputConfigurationProvider::SRC_OUTPUT, comp.CoreUserHeaderFileContent);
			fsa.generateFile(comp.getCoreUserSourceFilename, ExtendedOutputConfigurationProvider::SRC_OUTPUT, comp.CoreUserSourceFileContent);
			
			// cmake
			fsa.generateFile("CMakeLists.txt", ExtendedOutputConfigurationProvider::SMARTSOFT_OUTPUT, comp.CMakeListsUserFileContent);
			fsa.generateFile(".gitignore", ExtendedOutputConfigurationProvider::SMARTSOFT_OUTPUT, comp.compileDefaultGitignore);
			fsa.generateFile("ComponentProject.cmake", comp.generateCmakeProjectFile);
			fsa.generateFile(comp.name+"Dependencies.cmake.in", comp.generateCmakeDependenciesFile);
//			fsa.generateFile("GenerateDebianControl.cmake",c.generateCMakeDebianControlFile);
			fsa.generateFile(CMakeMixedPortIncludesFilename, comp.generateCMakeMixedPortIncludes)
			fsa.generateFile(CMakeMixedPortTargetConfigFilename, comp.generateCMakeMixedPortTargetConfigs)

			// ---- create component handler ----
			fsa.generateFile("CompHandler.hh", ExtendedOutputConfigurationProvider::SRC_OUTPUT, comp.CompHandlerHeaderFileContent);
			fsa.generateFile("CompHandler.cc", ExtendedOutputConfigurationProvider::SRC_OUTPUT, comp.CompHandlerSourceFileContent);

			// generate Tasks
			comp.activities.forEach[it.CreateSmartTask(fsa)]

			// generate InputHandlers
			comp.CreateSmartInputHandlers(fsa)
			
			// generate QueryHandlers
			comp.CreateQueryServerHandlers(fsa)
			
			// generate event-test handler
			comp.CreateEventTestHandlers(fsa)
			
//			c.eAllContents.filter(typeof(org.eclipse.uml2.uml.Class)).forEach(p | p.stereotype?.CreateSmartTimer(fsa))
			
			// generate state-change handler
			comp.CreateStateChangeHandler(fsa)
			
			// ---- create component documentation ----
// 			fsa.generateFile("documentation.dox", c.CompDocumentation);
			
			fsa.generateFile("predeploy.sh", ExtendedOutputConfigurationProvider::SRC_OUTPUT, comp.compilePredeployScript)
			fsa.generateFile("startstop-hooks.sh", ExtendedOutputConfigurationProvider::SRC_OUTPUT, comp.compileStartStopHooks)
			
			for(node: comp.elements.filter(ComponentSubNode)) {
				fsa.generateFile(node.nodeObserverInterfaceHeaderFileName, node.compileNodeObserverInterface)
			}
		}
	}
	
	def compileDefaultGitignore(ComponentDefinition comp)
	'''
	build/
	'''
	
	def compileToolchainVersionFile(ComponentDefinition comp)
	'''
	«toolchainVersionFileString»
	'''
	
	def compilePredeployScript(ComponentDefinition component)
	'''
	#!/bin/bash
	
	# Use this variable to name files that are to be deployed to the data
	# instance directory of
	# the component (<COMPONENT INSTANCE NAME>_data/) on the target host.
	#
	# Files can be relative to component project directory or absolute.
	# Add one file or directory per line.
	#
	# Examples:
	#
	# DEPLOY_LIBRARIES="../bin/libMyLibrary.so"
	#
	# DEPLOY_COMPONENT_FILES="
	# $SMART_ROOT_ACE/myFILE
	# $SMART_ROOT_ACE/myFILE2
	# "
	
	DEPLOY_LIBRARIES=""
	DEPLOY_COMPONENT_FILES=""
	'''
	
	def compileStartStopHooks(ComponentDefinition component)
	'''
	#!/bin/bash
	
	# This script provides methods to call custom commands pre/post of starting/stoping the component during launch on the device. 
	# This script is being executed on the target device where the component is running. 
	# For example the script can be used to start and stop the morse simulator automatically.
	
	case "$1" in
	
	pre-start)
		echo "Triggering pre-start hooks FROM COMPONENT «component.name» ..."
		# Insert commands you want to call prior to starting the components
	;;
	
	post-start)
		echo "Triggering post-start hooks FROM COMPONENT «component.name» ..."
		# Insert commands you want to call after all components were started
	;;
	
	pre-stop)
		echo "Triggering pre-stop hooks FROM COMPONENT «component.name» ..."
		# Insert commands you want to call before stopping all components
	;;
	
	post-stop)
		echo "Triggering post-stop hooks FROM COMPONENT «component.name» ..."
		# Insert commands you want to call after all components were stopped
	;;
	
	*)
		echo "ERROR in $0: no such hook '$1'. Usage: $0 pre-start|post-start|pre-stop|post-stop"
	;;
	
	esac
	'''
}
