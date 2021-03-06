/*
 * generated by Xtext 2.10.0
 */
package org.example.xbase.entities.formatting2

import org.eclipse.xtext.formatting2.IFormattableDocument
import org.eclipse.xtext.xbase.annotations.formatting2.XbaseWithAnnotationsFormatter
import org.example.xbase.entities.entities.Entity
import org.example.xbase.entities.entities.Model

import static org.example.xbase.entities.entities.EntitiesPackage.Literals.*

class EntitiesFormatter extends XbaseWithAnnotationsFormatter {

	def dispatch void format(Model model, extension IFormattableDocument document) {
		model.getImportSection.format;
		val lastEntity = model.entities.last
		for (entity : model.entities) {
			entity.format
			if (entity === lastEntity)
				entity.append[setNewLines(1)]
			else
				entity.append[setNewLines(2)]
		}
	}

	def dispatch void format(Entity entity, extension IFormattableDocument document) {
		for (annotation : entity.getAnnotations()) {
			annotation.format
			annotation.append[newLine]
		}
		for (typeParameter : entity.getTypeParameters()) {
			typeParameter.format
		}
		entity.regionFor.keyword("<").append[noSpace]
		entity.regionFor.keyword(">").prepend[noSpace]

		entity.getSuperType.format
		entity.getSuperType.surround[oneSpace]

		entity.regionFor.keyword("extends").surround[oneSpace]
		entity.regionFor.feature(ENTITY__NAME).surround[oneSpace]

		val open = entity.regionFor.keyword("{")
		val close = entity.regionFor.keyword("}")
		open.append[newLine]
		interior(open, close)[indent]

		for (attribute : entity.getAttributes()) {
			attribute.regionFor.keyword("attr").append[oneSpace]
			attribute.type.format(document)
			attribute.regionFor.keyword(";").surround[noSpace]
			attribute.append[setNewLines(1, 1, 2)]
		}
		for (operation : entity.getOperations()) {
			operation.regionFor.keyword("op").append[oneSpace]
			if (operation.type != null) {
				operation.type.append[oneSpace]
				operation.type.format
			}
			operation.regionFor.keyword("(").surround[noSpace]
			if (!operation.params.isEmpty) {
				for (comma : operation.regionFor.keywords(","))
					comma.prepend[noSpace].append[oneSpace]
				for (params : operation.params)
					params.format
			}
			operation.regionFor.keyword(")").prepend[noSpace]
			operation.body.format
			operation.append[setNewLines(1, 1, 2)]
		}
	}
}
