if(${input$entity} instanceof LivingEntity)
	((LivingEntity)${input$entity}).addStatusEffect(new StatusEffectInstance(${generator.map(field$potion, "effects")},(int) ${input$duration},(int) ${input$level}));