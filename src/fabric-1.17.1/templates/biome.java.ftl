<#--
 # This file is part of Fabric-Generator-MCreator.
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2021, Pylo, opensource contributors
 # Copyright (C) 2020-2022, Goldorion, opensource contributors
 #
 # Fabric-Generator-MCreator is free software: you can redistribute it and/or modify
 # it under the terms of the GNU Lesser General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.

 # Fabric-Generator-MCreator is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 # GNU Lesser General Public License for more details.
 #
 # You should have received a copy of the GNU Lesser General Public License
 # along with Fabric-Generator-MCreator.  If not, see <https://www.gnu.org/licenses/>.
-->

<#-- @formatter:off -->
<#include "mcitems.ftl">

<#assign hasConfiguredFeatures = false/>

package ${package}.world.biome;

import net.minecraftforge.common.BiomeManager;
import net.minecraft.sounds.SoundEvent;

import com.google.common.collect.ImmutableList;

public class ${name}Biome {

	private static final ConfiguredSurfaceBuilder<?> SURFACE_BUILDER = SurfaceBuilder.DEFAULT.configured(new SurfaceBuilderBaseConfiguration(
            ${mappedBlockToBlockStateCode(data.groundBlock)},
            ${mappedBlockToBlockStateCode(data.undergroundBlock)},
            ${mappedBlockToBlockStateCode(data.undergroundBlock)}));

    public static Biome createBiome() {
            BiomeSpecialEffects effects = new BiomeSpecialEffects.Builder()
                .fogColor(${data.airColor?has_content?then(data.airColor.getRGB(), 12638463)})
                .waterColor(${data.waterColor?has_content?then(data.waterColor.getRGB(), 4159204)})
                .waterFogColor(${data.waterFogColor?has_content?then(data.waterFogColor.getRGB(), 329011)})
                .skyColor(${data.airColor?has_content?then(data.airColor.getRGB(), 7972607)})
                .foliageColorOverride(${data.foliageColor?has_content?then(data.foliageColor.getRGB(), 10387789)})
                .grassColorOverride(${data.grassColor?has_content?then(data.grassColor.getRGB(), 9470285)})
                <#if data.ambientSound?has_content && data.ambientSound.getMappedValue()?has_content>
                    .ambientLoopSound(new SoundEvent(new ResourceLocation("${data.ambientSound}")))
                </#if>
                <#if data.moodSound?has_content && data.moodSound.getMappedValue()?has_content>
                    .ambientMoodSound(new AmbientMoodSettings(new SoundEvent(new ResourceLocation("${data.moodSound}")), ${data.moodSoundDelay}, 8, 2))
                </#if>
                <#if data.additionsSound?has_content && data.additionsSound.getMappedValue()?has_content>
                    .ambientAdditionsSound(new AmbientAdditionsSettings(new SoundEvent(new ResourceLocation("${data.additionsSound}")), 0.0111D))
                </#if>
                <#if data.music?has_content && data.music.getMappedValue()?has_content>
                    .backgroundMusic(new Music(new SoundEvent(new ResourceLocation("${data.music}")), 12000, 24000, true))
                </#if>
                <#if data.spawnParticles>
                    .ambientParticle(new AmbientParticleSettings(${data.particleToSpawn}, ${data.particlesProbability / 100}f))
                </#if>
                .build();

        BiomeGenerationSettings.Builder biomeGenerationSettings = new BiomeGenerationSettings.Builder().surfaceBuilder(SURFACE_BUILDER);

        <#if data.spawnStronghold>
            biomeGenerationSettings.addStructureStart(StructureFeatures.STRONGHOLD);
        </#if>

        <#if data.spawnMineshaft>
            biomeGenerationSettings.addStructureStart(StructureFeatures.MINESHAFT);
        </#if>

        <#if data.spawnPillagerOutpost>
            biomeGenerationSettings.addStructureStart(StructureFeatures.PILLAGER_OUTPOST);
        </#if>

        <#if data.villageType != "none">
            biomeGenerationSettings.addStructureStart(StructureFeatures.VILLAGE_${data.villageType?upper_case});
        </#if>

        <#if data.spawnWoodlandMansion>
            biomeGenerationSettings.addStructureStart(StructureFeatures.WOODLAND_MANSION);
        </#if>

        <#if data.spawnJungleTemple>
            biomeGenerationSettings.addStructureStart(StructureFeatures.JUNGLE_TEMPLE);
        </#if>

        <#if data.spawnDesertPyramid>
            biomeGenerationSettings.addStructureStart(StructureFeatures.DESERT_PYRAMID);
        </#if>

        <#if data.spawnIgloo>
            biomeGenerationSettings.addStructureStart(StructureFeatures.IGLOO);
        </#if>

        <#if data.spawnOceanMonument>
            biomeGenerationSettings.addStructureStart(StructureFeatures.OCEAN_MONUMENT);
        </#if>

        <#if data.spawnShipwreck>
            biomeGenerationSettings.addStructureStart(StructureFeatures.SHIPWRECK);
        </#if>

        <#if data.oceanRuinType != "NONE">
            biomeGenerationSettings.addStructureStart(StructureFeatures.OCEAN_RUIN_${data.oceanRuinType});
        </#if>

        <#if (data.treesPerChunk > 0)>
        	<#assign ct = data.treeType == data.TREES_CUSTOM>
            <#assign hasConfiguredFeatures = true/>

        	<#if data.vanillaTreeType == "Big trees">
        	biomeGenerationSettings.addFeature(GenerationStep.Decoration.VEGETAL_DECORATION,
				register("trees", Feature.TREE.configured((new TreeConfiguration.TreeConfigurationBuilder(
                    new SimpleStateProvider(${ct?then(mappedBlockToBlockStateCode(data.treeStem), "Blocks.JUNGLE_LOG.defaultBlockState()")}),
                    new MegaJungleTrunkPlacer(${ct?then(data.minHeight, 10)}, 2, 19),
                    new SimpleStateProvider(${ct?then(mappedBlockToBlockStateCode(data.treeBranch), "Blocks.JUNGLE_LEAVES.defaultBlockState()")}),
                    new SimpleStateProvider(Blocks.OAK_SAPLING.defaultBlockState()),
                    new MegaJungleFoliagePlacer(ConstantInt.of(2), ConstantInt.of(0), 2),
                    new TwoLayersFeatureSize(1, 1, 2)))
                    .decorators(ImmutableList.of(TrunkVineDecorator.INSTANCE, LeaveVineDecorator.INSTANCE))
            	.build())
            	.decorated(FeatureDecorator.HEIGHTMAP.configured(new HeightmapConfiguration(Heightmap.Types.MOTION_BLOCKING)).squared())
            	.decorated(FeatureDecorator.COUNT_EXTRA.configured(new FrequencyWithExtraChanceDecoratorConfiguration(${data.treesPerChunk}, 0.1F, 1))))
        	);
        	<#elseif data.vanillaTreeType == "Savanna trees">
        	biomeGenerationSettings.addFeature(GenerationStep.Decoration.VEGETAL_DECORATION,
                register("trees", Feature.TREE.configured((new TreeConfiguration.TreeConfigurationBuilder(
                    new SimpleStateProvider(${ct?then(mappedBlockToBlockStateCode(data.treeStem), "Blocks.ACACIA_LOG.defaultBlockState()")}),
                    new ForkingTrunkPlacer(${ct?then(data.minHeight, 5)}, 2, 2),
                    new SimpleStateProvider(${ct?then(mappedBlockToBlockStateCode(data.treeBranch), "Blocks.ACACIA_LEAVES.defaultBlockState()")}),
                    new SimpleStateProvider(Blocks.ACACIA_SAPLING.defaultBlockState()),
                    new AcaciaFoliagePlacer(ConstantInt.of(2), ConstantInt.of(0)),
                    new TwoLayersFeatureSize(1, 0, 2)))
                    .ignoreVines()
            	.build())
            	.decorated(FeatureDecorator.HEIGHTMAP.configured(new HeightmapConfiguration(Heightmap.Types.MOTION_BLOCKING)).squared())
            	.decorated(FeatureDecorator.COUNT_EXTRA.configured(new FrequencyWithExtraChanceDecoratorConfiguration(${data.treesPerChunk}, 0.1F, 1))))
        	);
        	<#elseif data.vanillaTreeType == "Mega pine trees">
        	biomeGenerationSettings.addFeature(GenerationStep.Decoration.VEGETAL_DECORATION,
				register("trees", Feature.TREE.configured((new TreeConfiguration.TreeConfigurationBuilder(
                    new SimpleStateProvider(${ct?then(mappedBlockToBlockStateCode(data.treeStem), "Blocks.SPRUCE_LOG.defaultBlockState()")}),
                    new GiantTrunkPlacer(${ct?then(data.minHeight, 13)}, 2, 14),
                    new SimpleStateProvider(${ct?then(mappedBlockToBlockStateCode(data.treeBranch), "Blocks.SPRUCE_LEAVES.defaultBlockState()")}),
                    new SimpleStateProvider(Blocks.SPRUCE_SAPLING.defaultBlockState()),
                    new MegaPineFoliagePlacer(ConstantInt.of(0), ConstantInt.of(0), UniformInt.of(3, 4)),
                    new TwoLayersFeatureSize(1, 1, 2)))
            	.build())
            	.decorated(FeatureDecorator.HEIGHTMAP.configured(new HeightmapConfiguration(Heightmap.Types.MOTION_BLOCKING)).squared())
            	.decorated(FeatureDecorator.COUNT_EXTRA.configured(new FrequencyWithExtraChanceDecoratorConfiguration(${data.treesPerChunk}, 0.1F, 1))))
        	);
        	<#elseif data.vanillaTreeType == "Mega spruce trees">
        	biomeGenerationSettings.addFeature(GenerationStep.Decoration.VEGETAL_DECORATION,
				register("trees", Feature.TREE.configured((new TreeConfiguration.TreeConfigurationBuilder(
                    new SimpleStateProvider(${ct?then(mappedBlockToBlockStateCode(data.treeStem), "Blocks.SPRUCE_LOG.defaultBlockState()")}),
                    new GiantTrunkPlacer(${ct?then(data.minHeight, 13)}, 2, 14),
                    new SimpleStateProvider(${ct?then(mappedBlockToBlockStateCode(data.treeBranch), "Blocks.SPRUCE_LEAVES.defaultBlockState()")}),
                    new SimpleStateProvider(Blocks.SPRUCE_SAPLING.defaultBlockState()),
                    new MegaPineFoliagePlacer(ConstantInt.of(0), ConstantInt.of(0), UniformInt.of(13, 17)),
                    new TwoLayersFeatureSize(1, 1, 2)))
                    .decorators(ImmutableList.of(new AlterGroundDecorator(new SimpleStateProvider(Blocks.PODZOL.defaultBlockState()))))
            	.build())
            	.decorated(FeatureDecorator.HEIGHTMAP.configured(new HeightmapConfiguration(Heightmap.Types.MOTION_BLOCKING)).squared())
            	.decorated(FeatureDecorator.COUNT_EXTRA.configured(new FrequencyWithExtraChanceDecoratorConfiguration(${data.treesPerChunk}, 0.1F, 1))))
        	);
        	<#elseif data.vanillaTreeType == "Birch trees">
        	biomeGenerationSettings.addFeature(GenerationStep.Decoration.VEGETAL_DECORATION,
				register("trees", Feature.TREE.configured((new TreeConfiguration.TreeConfigurationBuilder(
                    new SimpleStateProvider(${ct?then(mappedBlockToBlockStateCode(data.treeStem), "Blocks.BIRCH_LOG.defaultBlockState()")}),
                    new StraightTrunkPlacer(${ct?then(data.minHeight, 5)}, 2, 0),
                    new SimpleStateProvider(${ct?then(mappedBlockToBlockStateCode(data.treeBranch), "Blocks.BIRCH_LEAVES.defaultBlockState()")}),
                    new SimpleStateProvider(Blocks.BIRCH_SAPLING.defaultBlockState()),
                    new BlobFoliagePlacer(ConstantInt.of(2), ConstantInt.of(0), 3),
                    new TwoLayersFeatureSize(1, 0, 1)))
                    .ignoreVines()
            	.build())
            	.decorated(FeatureDecorator.HEIGHTMAP.configured(new HeightmapConfiguration(Heightmap.Types.MOTION_BLOCKING)).squared())
            	.decorated(FeatureDecorator.COUNT_EXTRA.configured(new FrequencyWithExtraChanceDecoratorConfiguration(${data.treesPerChunk}, 0.1F, 1))))
        	);
        	<#else>
        	biomeGenerationSettings.addFeature(GenerationStep.Decoration.VEGETAL_DECORATION,
				register("trees", Feature.TREE.configured((new TreeConfiguration.TreeConfigurationBuilder(
                    new SimpleStateProvider(${ct?then(mappedBlockToBlockStateCode(data.treeStem), "Blocks.OAK_LOG.defaultBlockState()")}),
                    new StraightTrunkPlacer(${ct?then(data.minHeight, 4)}, 2, 0),
                    new SimpleStateProvider(${ct?then(mappedBlockToBlockStateCode(data.treeBranch), "Blocks.OAK_LEAVES.defaultBlockState()")}),
                    new SimpleStateProvider(Blocks.OAK_SAPLING.defaultBlockState()),
                    new BlobFoliagePlacer(ConstantInt.of(2), ConstantInt.of(0), 3),
                    new TwoLayersFeatureSize(1, 0, 1)))
                    .ignoreVines()
            	.build())
            	.decorated(FeatureDecorator.HEIGHTMAP.configured(new HeightmapConfiguration(Heightmap.Types.MOTION_BLOCKING)).squared())
            	.decorated(FeatureDecorator.COUNT_EXTRA.configured(new FrequencyWithExtraChanceDecoratorConfiguration(${data.treesPerChunk}, 0.1F, 1))))
        	);
        	</#if>
        </#if>

        <#if (data.grassPerChunk > 0)>
            <#assign hasConfiguredFeatures = true/>
            biomeGenerationSettings.addFeature(GenerationStep.Decoration.VEGETAL_DECORATION,
				register("grass", Feature.RANDOM_PATCH.configured(Features.Configs.DEFAULT_GRASS_CONFIG)
                .decorated(FeatureDecorator.HEIGHTMAP_SPREAD_DOUBLE.configured(new HeightmapConfiguration(Heightmap.Types.MOTION_BLOCKING)).squared())
                .decorated(FeatureDecorator.COUNT_NOISE.configured(new NoiseDependantDecoratorConfiguration(-0.8D, 5, ${data.grassPerChunk})))));
        </#if>

        <#if (data.seagrassPerChunk > 0)>
            <#assign hasConfiguredFeatures = true/>
            biomeGenerationSettings.addFeature(GenerationStep.Decoration.VEGETAL_DECORATION,
			    register("seagrass", Feature.SEAGRASS.configured(new ProbabilityFeatureConfiguration(0.3F))
                .count(${data.seagrassPerChunk})
                .decorated(FeatureDecorator.HEIGHTMAP.configured(new HeightmapConfiguration(Heightmap.Types.OCEAN_FLOOR_WG)).squared())));
        </#if>

        <#if (data.flowersPerChunk > 0)>
            <#assign hasConfiguredFeatures = true/>
            biomeGenerationSettings.addFeature(GenerationStep.Decoration.VEGETAL_DECORATION,
			    register("flower", Feature.FLOWER.configured(Features.Configs.DEFAULT_FLOWER_CONFIG)
                .decorated(FeatureDecorator.SPREAD_32_ABOVE.configured(NoneDecoratorConfiguration.INSTANCE))
                .decorated(FeatureDecorator.HEIGHTMAP.configured(new HeightmapConfiguration(Heightmap.Types.MOTION_BLOCKING)).squared())
                .count(${data.flowersPerChunk})));
        </#if>

        <#if (data.mushroomsPerChunk > 0)>
            <#assign hasConfiguredFeatures = true/>
            biomeGenerationSettings.addFeature(GenerationStep.Decoration.VEGETAL_DECORATION,
			    register("brown_mushroom", Feature.RANDOM_PATCH.configured((new RandomPatchConfiguration.GrassConfigurationBuilder(
                new SimpleStateProvider(Blocks.BROWN_MUSHROOM.defaultBlockState()), SimpleBlockPlacer.INSTANCE))
                .tries(${data.mushroomsPerChunk}).noProjection().build())));
            biomeGenerationSettings.addFeature(GenerationStep.Decoration.VEGETAL_DECORATION,
			    register("red_mushroom", Feature.RANDOM_PATCH.configured((new RandomPatchConfiguration.GrassConfigurationBuilder(
                new SimpleStateProvider(Blocks.RED_MUSHROOM.defaultBlockState()), SimpleBlockPlacer.INSTANCE))
                .tries(${data.mushroomsPerChunk}).noProjection().build())));
        </#if>

        <#if (data.bigMushroomsChunk > 0)>
            <#assign hasConfiguredFeatures = true/>
            biomeGenerationSettings.addFeature(GenerationStep.Decoration.VEGETAL_DECORATION,
			    register("brown_mushroom_huge", Feature.HUGE_BROWN_MUSHROOM.configured(new HugeMushroomFeatureConfiguration(
                new SimpleStateProvider(Blocks.BROWN_MUSHROOM_BLOCK.defaultBlockState().setValue(HugeMushroomBlock.UP, Boolean.TRUE).setValue(HugeMushroomBlock.DOWN, Boolean.FALSE)),
                new SimpleStateProvider(Blocks.MUSHROOM_STEM.defaultBlockState().setValue(HugeMushroomBlock.UP, Boolean.FALSE)
                .setValue(HugeMushroomBlock.DOWN, Boolean.FALSE)), ${data.bigMushroomsChunk}))));
            biomeGenerationSettings.addFeature(GenerationStep.Decoration.VEGETAL_DECORATION,
			    register("red_mushroom_huge", Feature.HUGE_RED_MUSHROOM.configured(new HugeMushroomFeatureConfiguration(
                new SimpleStateProvider(Blocks.RED_MUSHROOM_BLOCK.defaultBlockState().setValue(HugeMushroomBlock.DOWN, Boolean.FALSE)),
                new SimpleStateProvider(Blocks.MUSHROOM_STEM.defaultBlockState().setValue(HugeMushroomBlock.UP, Boolean.FALSE)
                .setValue(HugeMushroomBlock.DOWN, Boolean.FALSE)), ${data.bigMushroomsChunk}))));
        </#if>

        <#if (data.sandPatchesPerChunk > 0)>
            <#assign hasConfiguredFeatures = true/>
            biomeGenerationSettings.addFeature(GenerationStep.Decoration.VEGETAL_DECORATION,
			    register("disk_sand", Feature.DISK.configured(new DiskConfiguration(Blocks.SAND.defaultBlockState(), UniformInt.of(2, 4), 2,
                ImmutableList.of(${mappedBlockToBlockStateCode(data.groundBlock)}, ${mappedBlockToBlockStateCode(data.undergroundBlock)})))
                .decorated(FeatureDecorator.HEIGHTMAP.configured(new HeightmapConfiguration(Heightmap.Types.OCEAN_FLOOR_WG)).squared()).count(${data.sandPatchesPerChunk})));
        </#if>

        <#if (data.gravelPatchesPerChunk > 0)>
            <#assign hasConfiguredFeatures = true/>
            biomeGenerationSettings.addFeature(GenerationStep.Decoration.VEGETAL_DECORATION,
			    register("disk_gravel", Feature.DISK.configured(new DiskConfiguration(Blocks.GRAVEL.defaultBlockState(), UniformInt.of(2, 3), 2,
                ImmutableList.of(${mappedBlockToBlockStateCode(data.groundBlock)}, ${mappedBlockToBlockStateCode(data.undergroundBlock)})))
                .decorated(FeatureDecorator.HEIGHTMAP.configured(new HeightmapConfiguration(Heightmap.Types.OCEAN_FLOOR_WG)).squared()).count(${data.gravelPatchesPerChunk})));
        </#if>

        <#if (data.reedsPerChunk > 0)>
            <#assign hasConfiguredFeatures = true/>
            biomeGenerationSettings.addFeature(GenerationStep.Decoration.VEGETAL_DECORATION,
			    register("patch_sugar_cane", Feature.RANDOM_PATCH.configured(Features.Configs.SUGAR_CANE_CONFIG)
                .decorated(FeatureDecorator.HEIGHTMAP_SPREAD_DOUBLE.configured(new HeightmapConfiguration(Heightmap.Types.MOTION_BLOCKING)).squared()).count(${data.reedsPerChunk})));
        </#if>

        <#if (data.cactiPerChunk > 0)>
            <#assign hasConfiguredFeatures = true/>
            biomeGenerationSettings.addFeature(GenerationStep.Decoration.VEGETAL_DECORATION,
			    register("patch_cactus", Feature.RANDOM_PATCH.configured((new RandomPatchConfiguration.GrassConfigurationBuilder(
                new SimpleStateProvider(Blocks.CACTUS.defaultBlockState()), new ColumnPlacer(BiasedToBottomInt.of(1, 2))))
                .tries(${data.cactiPerChunk}).noProjection().build())));
        </#if>

        <#list data.defaultFeatures as defaultFeature>
        	<#assign mfeat = generator.map(defaultFeature, "defaultfeatures")>
        	<#if mfeat != "null">
            BiomeDefaultFeatures.add${mfeat}(biomeGenerationSettings);
        	</#if>
        </#list>

        MobSpawnSettings.Builder mobSpawnInfo = new MobSpawnSettings.Builder().setPlayerCanSpawn();
            <#list data.spawnEntries as spawnEntry>
                <#assign entity = generator.map(spawnEntry.entity.getUnmappedValue(), "entities", 1)!"null">
                    <#if entity != "null">
                	    mobSpawnInfo.addSpawn(${generator.map(spawnEntry.spawnType, "mobspawntypes")},
                		    new MobSpawnSettings.SpawnerData(${entity}, ${spawnEntry.weight}, ${spawnEntry.minGroup}, ${spawnEntry.maxGroup}));
                </#if>
            </#list>

        Biome biome = new Biome.BiomeBuilder()
            .precipitation(Biome.Precipitation.<#if (data.rainingPossibility > 0)><#if (data.temperature > 0.15)>RAIN<#else>SNOW</#if><#else>NONE</#if>)
            .biomeCategory(Biome.BiomeCategory.${data.biomeCategory})
            .depth(${data.baseHeight}f)
            .scale(${data.heightVariation}f)
            .temperature(${data.temperature}f)
            .downfall(${data.rainingPossibility}f)
            .specialEffects(effects)
            .mobSpawnSettings(mobSpawnInfo.build())
            .generationSettings(biomeGenerationSettings.build())
            .build();

        Registry.register(BuiltinRegistries.BIOME, ${JavaModName}Biomes.${registryname?upper_case}.location(), biome);

        <#if data.biomeDictionaryTypes?has_content>
            <#list data.biomeDictionaryTypes as type>
                <#if type = "NETHER">
                    NetherBiomes.addNetherBiome(${JavaModName}Biomes.${registryname?upper_case}, new Biome.ClimateParameters(${data.temperature}f, ${data.temperature}f, ${data.heightVariation}f, 0, ${data.biomeWeight}/1024f));
                <#elseif type = "VOID">
                    TheEndBiomes.addSmallIslandsBiome(${JavaModName}Biomes.${registryname?upper_case}, ${data.biomeWeight}d);
                <#elseif type = "RARE">
                    TheEndBiomes.addHighlandsBiome(${JavaModName}Biomes.${registryname?upper_case}, ${data.biomeWeight}d);
                </#if>
            </#list>
        </#if>

        <#if data.spawnBiome>
            OverworldBiomes.addContinentalBiome(${JavaModName}Biomes.${registryname?upper_case}, OverworldClimate.
            <#if (data.temperature < -0.25)>
                ICY
            <#elseif (data.temperature > -0.25) && (data.temperature <= 0.15)>
                COOL
            <#elseif (data.temperature > 0.15) && (data.temperature <= 1.0)>
            	TEMPERATE
            <#elseif (data.temperature > 1.0)>
            	DRY
            </#if>, ${data.biomeWeight}d);
        </#if>

        return biome;
    }

    <#if hasConfiguredFeatures>
        private static ConfiguredFeature<?, ?> register(String name, ConfiguredFeature<?, ?> configuredFeature) {
		    Registry.register(BuiltinRegistries.CONFIGURED_FEATURE, new ResourceLocation(${JavaModName}.MODID, name + "_${registryname}"), configuredFeature);
    	    return configuredFeature;
        }
    </#if>

}
<#-- @formatter:on -->
