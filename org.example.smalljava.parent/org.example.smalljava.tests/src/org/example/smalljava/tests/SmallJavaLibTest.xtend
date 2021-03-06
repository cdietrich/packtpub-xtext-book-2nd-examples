package org.example.smalljava.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.example.smalljava.SmallJavaLib
import org.example.smalljava.smallJava.SJProgram
import org.junit.Test
import org.junit.runner.RunWith

import static extension org.junit.Assert.*
import com.google.inject.Provider
import org.eclipse.emf.ecore.resource.ResourceSet

@RunWith(XtextRunner)
@InjectWith(SmallJavaInjectorProvider)
class SmallJavaLibTest {
	@Inject extension ParseHelper<SJProgram>
	@Inject extension ValidationTestHelper
	@Inject extension SmallJavaLib
	@Inject Provider<ResourceSet> rsp

	@Test def void testImplicitImports() {
		'''
			class C extends Object {
			  String s;
			  Integer i;
			  Object m(Boolean o) { return null; }
			}
		'''.loadLibAndParse.assertNoErrors
	}

	@Test def void testLibraryContainsNoError() {
		val resourceSet = rsp.get
		loadLib(resourceSet)
		resourceSet.resources.head.contents.head.assertNoErrors
	}

	@Test def void testSmallJavaObjectWithoutLibraryLoaded() {
		val context = '''class C {}'''.parse
		getSmallJavaObjectClass(context).assertNull
	}

	@Test def void testSmallJavaObjectWithLibraryLoaded() {
		val context = loadLibAndParse('''class C {}''')
		getSmallJavaObjectClass(context).assertNotNull
	}

	def private loadLibAndParse(CharSequence p) {
		val resourceSet = rsp.get
		loadLib(resourceSet)
		p.parse(resourceSet)
	}
}
