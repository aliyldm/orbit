package net.bigpoint.darkorbit.mvc.crafting.assembly.model
{
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeAvailableStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeBuildStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeKeyModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeReadyToCollectStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeStatusUpdateCommand;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeTemporaryTypeModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeTypeModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.items.ItemDataProvider;
   import net.bigpoint.darkorbit.items.item.Item;
   import net.bigpoint.darkorbit.items.item.ItemTraits;
   import net.bigpoint.darkorbit.items.item.attributes.BuildPart;
   import net.bigpoint.darkorbit.items.item.attributes.GeneralAttributes;
   import net.bigpoint.darkorbit.items.item.attributes.RecipeAttributes;
   import net.bigpoint.darkorbit.items.item.attributes.RecipeCosts;
   import net.bigpoint.darkorbit.items.item.traits.StackableTrait;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.AssemblyConsts;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.states.AbstractAssemblyState;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.states.AssemblyAvailableState;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.states.AssemblyTimerState;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.types.AbstractAssemblyType;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.types.AssemblyTemporaryType;
   import net.bigpoint.darkorbit.mvc.crafting.disassembly.model.DisassemblyRecipeModel;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.model.UpgraderecipeModel;
   import org.as3commons.lang.StringUtils;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class AssemblyModel
   {
      
      private static const _type2Class:Object = {};
      
      _type2Class[AssemblyRecipeTemporaryTypeModule.instance.getLibcomModuleId()] = AssemblyTemporaryType;
      
      private static var _localModulesApplied:Boolean = false;
      
      public const buildWarning:ISignal = new Signal();
      
      public const recipeAdded:ISignal = new Signal(AssemblyRecipeModel);
      
      public const recipeRemoved:ISignal = new Signal(AssemblyRecipeModel);
      
      private var _currentRecipes:Vector.<AssemblyRecipeModel> = new Vector.<AssemblyRecipeModel>(0);
      
      public function AssemblyModel()
      {
         super();
         applyLocalModuleCosts();
      }
      
      private static function applyLocalModuleCosts() : void
      {
         if(_localModulesApplied)
         {
            return;
         }
         _localModulesApplied = true;
         var a:GeneralAttributes = new GeneralAttributes();
         a.lootId = "resource_upgrade-module";
         a.typeClass = "net.bigpoint.darkorbit.asset.item.ItemType";
         a.typeValue = "UPGRADE_MODULE";
         a.uridium = 10000;
         a.maxQuantity = 0;
         var t:ItemTraits = new ItemTraits();
         var st:StackableTrait = new StackableTrait();
         st.maxQuantity = 1000000000;
         st.type = "stackable";
         t.add(st);
         ItemDataProvider.items[a.lootId] = new Item(a,t);
         a = new GeneralAttributes();
         a.lootId = "resource_convert-module";
         a.typeClass = "net.bigpoint.darkorbit.asset.item.ItemType";
         a.typeValue = "CONVERT_MODULE";
         a.uridium = 10000;
         a.maxQuantity = 0;
         t = new ItemTraits();
         st = new StackableTrait();
         st.maxQuantity = 1000000000;
         st.type = "stackable";
         t.add(st);
         ItemDataProvider.items[a.lootId] = new Item(a,t);
         var settings:Object = {
            "upgrade_upgrade-class0-drone":["resource_upgrade-module",[[1,1],[1,1],[1,1],[2,1],[2,1],[2,1],[3,2],[3,2],[3,2],[4,2],[4,2],[4,2],[5,3],[5,3],[5,3]]],
            "upgrade_upgrade-class2-neptune":["resource_upgrade-module",[[3,1],[3,1],[3,2],[6,2],[6,3],[6,3],[9,4],[9,4],[9,5],[12,5],[12,6],[12,6],[15,7],[15,7],[15,8],[18,8],[18,9],[18,9],[21,10]]],
            "upgrade_upgrade-class8":["resource_upgrade-module",[[9,2],[9,3],[9,5],[18,6],[18,8],[18,9],[27,11],[27,12],[27,14],[36,15],[36,17],[36,18],[45,20],[45,21],[45,23],[54,24],[54,26],[54,27],[63,29]]],
            "upgrade_upgrade-class2-ouroboros":["resource_upgrade-module",[[3,1],[3,1],[3,2],[6,2],[6,3],[6,3],[9,4],[9,4],[9,5],[12,5],[12,6],[12,6],[15,7],[15,7],[15,8],[18,8],[18,9],[18,9],[21,10]]],
            "upgrade_upgrade-class9":["resource_upgrade-module",[[10,2],[10,4],[10,5],[20,7],[20,9],[20,10],[30,12],[30,14],[30,15],[40,17],[40,19],[40,20],[50,22],[50,24],[50,25],[60,27],[60,29],[60,30],[70,32]]],
            "upgrade_upgrade-class10":["resource_upgrade-module",[[11,2],[11,4],[11,6],[22,8],[22,10],[22,11],[33,13],[33,15],[33,17],[44,19],[44,21],[44,22],[55,24],[55,26],[55,28],[66,30],[66,32],[66,33],[77,35]]],
            "upgrade_upgrade-class6":["resource_upgrade-module",[[7,2],[7,3],[7,4],[14,5],[14,6],[14,7],[21,9],[21,10],[21,11],[28,12],[28,13],[28,14],[35,16],[35,17],[35,18],[42,19],[42,20],[42,21],[49,23]]],
            "upgrade_upgrade-class2-hydra":["resource_upgrade-module",[[3,1],[3,1],[3,2],[6,2],[6,3],[6,3],[9,4],[9,4],[9,5],[12,5],[12,6],[12,6],[15,7],[15,7],[15,8],[18,8],[18,9],[18,9],[21,10]]],
            "upgrade_upgrade-class2-drone":["resource_upgrade-module",[[3,1],[3,1],[3,2],[6,2],[6,3],[6,3],[9,4],[9,4],[9,5],[12,5],[12,6],[12,6],[15,7],[15,7],[15,8]]],
            "upgrade_upgrade-class5":["resource_upgrade-module",[[6,1],[6,2],[6,3],[12,4],[12,5],[12,6],[18,7],[18,8],[18,9],[24,10],[24,11],[24,12],[30,13],[30,14],[30,15],[36,16],[36,17],[36,18],[42,19]]],
            "upgrade_upgrade-class2":["resource_upgrade-module",[[3,1],[3,1],[3,2],[6,2],[6,3],[6,3],[9,4],[9,4],[9,5],[12,5],[12,6],[12,6],[15,7],[15,7],[15,8],[18,8],[18,9],[18,9],[21,10]]],
            "upgrade_upgrade-class1":["resource_upgrade-module",[[2,1],[2,1],[2,1],[4,2],[4,2],[4,2],[6,3],[6,3],[6,3],[8,4],[8,4],[8,4],[10,5],[10,5],[10,5]]],
            "upgrade_upgrade-class2-triskelion":["resource_upgrade-module",[[3,1],[3,1],[3,2],[6,2],[6,3],[6,3],[9,4],[9,4],[9,5],[12,5],[12,6],[12,6],[15,7],[15,7],[15,8],[18,8],[18,9],[18,9],[21,10]]],
            "upgrade_upgrade-class0":["resource_upgrade-module",[[1,1],[1,1],[1,1],[2,1],[2,1],[2,1],[3,2],[3,2],[3,2],[4,2],[4,2],[4,2],[5,3],[5,3],[5,3]]],
            "upgrade_upgrade-class7":["resource_upgrade-module",[[8,2],[8,3],[8,4],[16,6],[16,7],[16,8],[24,10],[24,11],[24,12],[32,14],[32,15],[32,16],[40,18],[40,19],[40,20],[48,22],[48,23],[48,24],[56,26]]],
            "recipe_blueprint-hstrm-01-empyrian":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-ship-pusat-plus":["resource_convert-module",[[100,0]]],
            "recipe_blueprint-phantom-legend":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-shd-holo-10x":["resource_convert-module",[[150,0]]],
            "recipe_blueprint-season-solace-plus-striker":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-flower-token-emp-01":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-agate-hp-s01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-shd-sk01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-champion-pet-spectrum-seraph":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-booty-key-worldboss":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-extra-energy-atlas-m":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-aa1-sr5-75":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-goliath-phantasm":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-champion-ship-sentinel-seraph":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-chromin-zephyr":["resource_convert-module",[[24,0]]],
            "recipe_blueprint-dmg-x1":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-flower-token-frozen-labyrinth-key":["resource_convert-module",[[5,0]]],
            "recipe_blueprint-champion-ship-orcus-seraph":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-tech-energyleech-uridium":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-phantom-ocean":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-agate-lf4":["resource_convert-module",[[6,0]]],
            "recipe_recipe-test17":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-red-booty-key":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-chromin-emp01":["resource_convert-module",[[5,0]]],
            "recipe_blueprint-g-vanquisher":["resource_convert-module",[[30,0]]],
            "recipe_blueprint-drone-erythros":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-sg3n-b02":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-ship-solaris-plus":["resource_convert-module",[[100,0]]],
            "recipe_blueprint-flower-token-dd-m1":["resource_convert-module",[[1,0]]],
            "recipe_recipe-test28":["resource_convert-module",[[2,0]]],
            "recipe_blueprint-agate-spc-npc01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-extra-energy-worldboss":["resource_convert-module",[[1,0]]],
            "recipe_recipe-test29":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-ucb-100":["resource_convert-module",[[2,0]]],
            "recipe_blueprint-lf-4-hp":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-ship-goliath-plus":["resource_convert-module",[[100,0]]],
            "recipe_blueprint-opitite-shd-dlb-5":["resource_convert-module",[[500,0]]],
            "recipe_blueprint-ai-lm1":["resource_convert-module",[[5,0]]],
            "recipe_blueprint-polychromium-l-valentine":["resource_convert-module",[[500,0]]],
            "recipe_blueprint-rsb-75":["resource_convert-module",[[50,0]]],
            "recipe_blueprint-salvage-core-empyrian-limited":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-apocalypse-booty-key":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-ai-sm1":["resource_convert-module",[[5,0]]],
            "recipe_blueprint-chimera-argon":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-permit-worldboss":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-chromin-rcb140":["resource_convert-module",[[260,0]]],
            "recipe_blueprint-ship-tartarus-plus":["resource_convert-module",[[100,0]]],
            "recipe_blueprint-drone-pusat-blaze":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-seprom-blacklight":["resource_convert-module",[[5000,0]]],
            "recipe_blueprint-flower-token-battle-pass-key":["resource_convert-module",[[4,0]]],
            "recipe_blueprint-hp-xt10-empyrian-limited":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-dmg-leo01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-berserker-amor":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-chromin-mimesis":["resource_convert-module",[[28,0]]],
            "recipe_blueprint-a-elite-poison":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-spc-xh01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-chromin-permit":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-sandstorm-phantom":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-flower-token-explosive-charging-blob":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-drone-pusat-lava":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-season-diminisher-eldritch":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-flower-token-log-disks":["resource_convert-module",[[30,0]]],
            "recipe_blueprint-ai-eco1-2":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-chromin-spc-spe01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-wiz-x-empyrian-limited":["resource_convert-module",[[3,0]]],
            "recipe_recipe-test6":["resource_convert-module",[[4,0]]],
            "recipe_blueprint-spectrum-frost":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-agate-ggeu-limited":["resource_convert-module",[[50,0]]],
            "recipe_blueprint-blaze-mirage":["resource_convert-module",[[1,0]]],
            "recipe_recipe-test4":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-sentinel":["resource_convert-module",[[30,0]]],
            "recipe_blueprint-borealis-enigma":["resource_convert-module",[[10,0]]],
            "recipe_recipe-test19":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-shd-xt10-empyrian":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-sll-03":["resource_convert-module",[[2,0]]],
            "recipe_blueprint-scrapium-empyrian-m":["resource_convert-module",[[100,0]]],
            "recipe_blueprint-subglacial-cpu":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-polychromium-empyrian-s":["resource_convert-module",[[500,0]]],
            "recipe_blueprint-1hbooster-cd":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-chromin-solaris-plus-ullrin":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-module-hull":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-agate-asimov-solace-plus":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-drive-gl-chron":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-1hbooster-shd":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-drone-apis":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-seprom-empyrian-s":["resource_convert-module",[[100,0]]],
            "recipe_blueprint-opitite-ecb":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-fwx-com-multiple-valentine":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-shd-zpve-worldboss":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-flower-token-frost-field":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-spectrum-poison":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-season-hyperion-cerevisia":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-1hbooster-hp":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-agate-spc-sl01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-flower-token-scrapium":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-season-retiarus-plus-wyvern":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-pusat-blaze":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-drone-a-elite-poison":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-g-bc1":["resource_convert-module",[[5,0]]],
            "recipe_blueprint-nano-case":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-flower-token-dcr-250":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-lf-p01":["resource_convert-module",[[3,0]]],
            "recipe_blueprint-shd-dim01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-drone-intimidator":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-chromin-solace-ullrin":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-candy-phantasm-berserker":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-ai-aim1":["resource_convert-module",[[5,0]]],
            "recipe_blueprint-agate-tyrannos-spectrum":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-abr-worldboss":["resource_convert-module",[[250,0]]],
            "recipe_blueprint-ggeu":["resource_convert-module",[[50,0]]],
            "recipe_blueprint-indoctrine-oil-worldboss":["resource_convert-module",[[75,0]]],
            "recipe_blueprint-hp-xv02-valentine":["resource_convert-module",[[15,0]]],
            "recipe_recipe-test11":["resource_convert-module",[[30,0]]],
            "recipe_blueprint-indra-cyborg":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-agate-speed-burst":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-champion-drone-diminisher-eldritch":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-solaris-psyche":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-flower-token-sl-m01":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-darksilver-coin-atlas":["resource_convert-module",[[25,0]]],
            "recipe_blueprint-keres":["resource_convert-module",[[30,0]]],
            "recipe_blueprint-a-elite-ocean":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-polychromium-m-valentine":["resource_convert-module",[[300,0]]],
            "recipe_blueprint-job-100-10k-valentine":["resource_convert-module",[[100,0]]],
            "recipe_blueprint-diametrion-empyrian-l":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-emaa-20-10k-once":["resource_convert-module",[[100,0]]],
            "recipe_blueprint-ajp-01":["resource_convert-module",[[8,0]]],
            "recipe_blueprint-cyborg-psyche":["resource_convert-module",[[20,0]]],
            "recipe_recipe-test8":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-g-peacemaker":["resource_convert-module",[[30,0]]],
            "recipe_blueprint-agate-g-mm1":["resource_convert-module",[[5,0]]],
            "recipe_blueprint-hydra":["resource_convert-module",[[2,0]]],
            "recipe_blueprint-hp-zpve":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-flower-token-eternal-fragment":["resource_convert-module",[[250,0]]],
            "recipe_blueprint-palladium-empyrian-l":["resource_convert-module",[[600,0]]],
            "recipe_blueprint-leg-nidhogg":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-mirage-green":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-hp-xh01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-flower-token-prismatium":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-chromin-polychromium":["resource_convert-module",[[1000,0]]],
            "recipe_blueprint-sg3n-p01":["resource_convert-module",[[2,0]]],
            "recipe_blueprint-spectrum-blaze":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-tech-energyleech":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-champion-ship-centurion-tyrannos":["resource_convert-module",[[20,0]]],
            "recipe_recipe-test15":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-hp-t01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-dmg-holo-10x":["resource_convert-module",[[150,0]]],
            "recipe_blueprint-flower-token-borealis-berserker-pet-design":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-brb2-worldboss":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-ship-retiarus-plus":["resource_convert-module",[[100,0]]],
            "recipe_blueprint-ship-spearhead-plus":["resource_convert-module",[[100,0]]],
            "recipe_blueprint-prismatium-empyrian-m":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-venom":["resource_convert-module",[[30,0]]],
            "recipe_blueprint-leg-helios":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-sg3n-b01":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-bat-red":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-chromin-pusat-plus-ullrin":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-indra-spectrum-plus":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-u-lf-4-permanent":["resource_convert-module",[[6,0]]],
            "recipe_blueprint-g-champion":["resource_convert-module",[[30,0]]],
            "recipe_blueprint-flower-token-lf-p01":["resource_convert-module",[[3,0]]],
            "recipe_blueprint-ggeu-atlas-s":["resource_convert-module",[[100,0]]],
            "recipe_blueprint-shd-x1":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-flower-token-chain-impulse":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-flower-token-h-nco":["resource_convert-module",[[2,0]]],
            "recipe_blueprint-hp-xu01-empyrian":["resource_convert-module",[[15,0]]],
            "recipe_recipe-test14":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-drone-iris":["resource_convert-module",[[4,0]]],
            "recipe_blueprint-drone-apis-part":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-polychromium-empyrian-m":["resource_convert-module",[[1000,0]]],
            "recipe_blueprint-permit-plus":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-flower-token-npc-nuke":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-agate-dmg-mtch01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-permitplus-worldboss":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-solaris-amor":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-f-03-la":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-agate-asimov-orcus":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-ai-e1":["resource_convert-module",[[5,0]]],
            "recipe_blueprint-prometheus-laser":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-champion-ship-sentinel-harbinger":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-chromin-cyborg-ullrin":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-flower-token-iac":["resource_convert-module",[[50,0]]],
            "recipe_blueprint-flower-token-abr":["resource_convert-module",[[150,0]]],
            "recipe_blueprint-flower-token-r-ic3":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-agate-shd-bach01":["resource_convert-module",[[15,0]]],
            "recipe_recipe-test13":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-champion-pet-spectrum-harbinger":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-emaa-20-10k-repeat":["resource_convert-module",[[100,0]]],
            "recipe_blueprint-flower-token-h-hfc":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-season-spc-xsp01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-nano-condenser":["resource_convert-module",[[2,0]]],
            "recipe_blueprint-black-booty-key":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-agate-asimov-zephyr":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-captain-generic":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-micro-transitors":["resource_convert-module",[[4,0]]],
            "recipe_blueprint-npc-nuke-empyrian":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-ship-solace-plus":["resource_convert-module",[[100,0]]],
            "recipe_blueprint-emaa-20-3500-laser":["resource_convert-module",[[35,0]]],
            "recipe_blueprint-v-lightning-frost":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-blacklight-decoder":["resource_convert-module",[[100,0]]],
            "recipe_blueprint-dmg-zpve-worldboss":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-chromin-hammerclaw-ullrin":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-drone-zeus-part":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-drive-igd-l01":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-opitite-ccd-15k":["resource_convert-module",[[150,0]]],
            "recipe_blueprint-tech-battlerepairbot-uridium":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-flower-token-clo4k-xl-cpu":["resource_convert-module",[[3,0]]],
            "recipe_blueprint-flower-token-h-ps":["resource_convert-module",[[2,0]]],
            "recipe_blueprint-flower-token-booty-key":["resource_convert-module",[[30,0]]],
            "recipe_blueprint-npc-nuke-valentine":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-indoctrine-oil-atlas":["resource_convert-module",[[75,0]]],
            "recipe_blueprint-ggeu-atlas-m":["resource_convert-module",[[200,0]]],
            "recipe_blueprint-cl04k-xs":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-champion-ship-disruptor-seraph":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-spc-xt10":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-fwx-l-halloween":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-g-bh1":["resource_convert-module",[[5,0]]],
            "recipe_blueprint-precision-targeter-worldboss":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-g-sovereign":["resource_convert-module",[[30,0]]],
            "recipe_blueprint-rsb-75-1-worldboss":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-sab-50-1-worldboss":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-dmg-xt10-empyrian":["resource_convert-module",[[15,0]]],
            "recipe_recipe-test27":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-sab50-1k":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-booty-key-empyrian-limited":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-venom-frost":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-champion-pet-diminisher-eldritch":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-chromin-c-elite-ullrin":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-season-cyborg-horus":["resource_convert-module",[[20,0]]],
            "recipe_recipe-test2":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-polychromium-s-valentine":["resource_convert-module",[[200,0]]],
            "recipe_blueprint-shd-xu01-empyrian":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-g-fs1":["resource_convert-module",[[5,0]]],
            "recipe_recipe-test31":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-emaa-20-3500-laser-pet":["resource_convert-module",[[35,0]]],
            "recipe_blueprint-spectrum":["resource_convert-module",[[30,0]]],
            "recipe_blueprint-tech-precisiontargeter":["resource_convert-module",[[1,0]]],
            "recipe_recipe-test10":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-sl-03":["resource_convert-module",[[2,0]]],
            "recipe_blueprint-module-rocketla":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-extra-energy-500":["resource_convert-module",[[6,0]]],
            "recipe_blueprint-tech-battlerepairbot":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-ship-citadel-plus":["resource_convert-module",[[100,0]]],
            "recipe_blueprint-dmg-xu01-empyrian":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-chromin-seprom":["resource_convert-module",[[25000,0]]],
            "recipe_blueprint-a-bl-laser-ammo":["resource_convert-module",[[250,0]]],
            "recipe_blueprint-1hbooster-xp":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-flower-token-h-hp":["resource_convert-module",[[4,0]]],
            "recipe_blueprint-spc-holo-10x":["resource_convert-module",[[150,0]]],
            "recipe_blueprint-agate-tyrannos-g-champion":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-pet-goliath-x-ocean":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-hp-zpve-worldboss":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-shd-xt10":["resource_convert-module",[[15,0]]],
            "recipe_recipe-test25":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-sab-50-50-worldboss":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-pet-goliath-x-sandstorm":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-g-centaur":["resource_convert-module",[[30,0]]],
            "recipe_blueprint-flower-token-mucosum":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-goliath-x-regular":["resource_convert-module",[[30,0]]],
            "recipe_blueprint-flower-token-boltrum":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-centurion":["resource_convert-module",[[100,0]]],
            "recipe_blueprint-candy-dmg-npc01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-ship-spectrum-plus":["resource_convert-module",[[100,0]]],
            "recipe_blueprint-champion-ship-hecate-tyrannos":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-shd-xv02":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-spc-xa01-atlas":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-agate-spc-mtch01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-flower-token-black-light-shard":["resource_convert-module",[[2000,0]]],
            "recipe_blueprint-chimera-green":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-champion-ship-diminisher-seraph":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-high-frequency-cable":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-a-elite-legend":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-champion-drone-centurion-seraph":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-polychromium-empyrian-limited":["resource_convert-module",[[820,0]]],
            "recipe_blueprint-aap-1":["resource_convert-module",[[3,0]]],
            "recipe_blueprint-drone-infiltrator-1":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-agate-shd-sl01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-spc-xv02":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-prismatium-empyrian-l":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-lf-3":["resource_convert-module",[[3,0]]],
            "recipe_blueprint-module-repair":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-agate-abr-limited":["resource_convert-module",[[100,0]]],
            "recipe_blueprint-immunizer-cpu":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-champion-ship-cyborg-seraph":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-lf-5-mf":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-tech-chainpulse-uridium":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-upgrade-resource-isochronate":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-flower-token-hybrid-alloy":["resource_convert-module",[[30,0]]],
            "recipe_blueprint-opitite-dmg-dlb2-5":["resource_convert-module",[[500,0]]],
            "recipe_blueprint-extra-energy-empyrian-l":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-flower-token-burning-trail":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-caucasus-laser":["resource_convert-module",[[2,0]]],
            "recipe_blueprint-champion-pet-sentinel-harbinger":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-prismatium-empyrian-limited":["resource_convert-module",[[5,0]]],
            "recipe_blueprint-borealis-phantom":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-pet-goliath-x-borealis":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-agate-spc-spd01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-spartan":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-hp-x1":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-sg3n-b03":["resource_convert-module",[[2,0]]],
            "recipe_blueprint-shd-xa01-atlas":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-tarnom-lf-4-md":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-module-laserhr":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-prismatium-empyrian-s":["resource_convert-module",[[5,0]]],
            "recipe_blueprint-dmg-x2":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-cyborg":["resource_convert-module",[[32,0]]],
            "recipe_blueprint-captain-gen2-eos-worldboss":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-spectrum-legend":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-ubr-100":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-tartarus-poison":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-pet-spectrum-blaze":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-bs2-worldboss":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-chaos-alien-cpu-common":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-tartarus-ocean":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-extra-energy-empyrian-limited":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-tarnom-lf-4-pd":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-mimesis":["resource_convert-module",[[28,0]]],
            "recipe_blueprint-pet-phantasm":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-agate-tyrannos-sentinel":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-phantom-poison":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-champion-ship-diminisher-harbinger":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-hp-xt10":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-sar-02":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-ouroboros":["resource_convert-module",[[2,0]]],
            "recipe_blueprint-chromin-hecate":["resource_convert-module",[[30,0]]],
            "recipe_blueprint-chromin-disruptor-ullrin":["resource_convert-module",[[20,0]]],
            "recipe_recipe-test5":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-extra-energy-empyrian-m":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-lottery-capsule":["resource_convert-module",[[2,0]]],
            "recipe_blueprint-candy-hp-a01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-chromin-sentinel-ullrin":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-n-ambassador-frost":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-chromin-hammerclaw":["resource_convert-module",[[24,0]]],
            "recipe_blueprint-spc-roc01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-module-lasermr":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-module-xp":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-ai-al1":["resource_convert-module",[[5,0]]],
            "recipe_blueprint-chromin-permit-plus":["resource_convert-module",[[5,0]]],
            "recipe_blueprint-sl-02":["resource_convert-module",[[2,0]]],
            "recipe_blueprint-agate-hp-sol01":["resource_convert-module",[[15,0]]],
            "recipe_recipe-test20":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-agate-asimov-sentinel":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-goliath-x-sandstorm":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-diminisher":["resource_convert-module",[[30,0]]],
            "recipe_blueprint-agate-g-hpl1":["resource_convert-module",[[5,0]]],
            "recipe_blueprint-flower-token-precision-targeter":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-season-shd-xsp01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-pusat-lava":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-pusat":["resource_convert-module",[[32,0]]],
            "recipe_blueprint-agate-asimov-pusat-plus":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-solace":["resource_convert-module",[[30,0]]],
            "recipe_blueprint-solace-contagion":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-indoctrine-accelerator-worldboss":["resource_convert-module",[[125,0]]],
            "recipe_blueprint-shd-xv01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-drone-infiltrator-2":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-phantom-green":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-palladium-empyrian-m":["resource_convert-module",[[300,0]]],
            "recipe_blueprint-glacial-fragment":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-1hbooster-res":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-dmg-xv02-valentine":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-champion-ship-solace-contagion":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-scrapium-empyrian-s":["resource_convert-module",[[50,0]]],
            "recipe_recipe-test23":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-chromin-holo-ullrin":["resource_convert-module",[[30,0]]],
            "recipe_blueprint-rsb75-40k":["resource_convert-module",[[400,0]]],
            "recipe_blueprint-drone-goliath-x-borealis":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-indra-solaris-plus":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-eternal-cpu":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-shd-zpve":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-drone-goliath-x-ocean":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-tech-precisiontargeter-uridium":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-pusat-frost":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-diametrion-empyrian-m":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-astral-cpu":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-agate-dmg-vp01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-ship-hecate-plus":["resource_convert-module",[[100,0]]],
            "recipe_blueprint-cc-c-12k":["resource_convert-module",[[120,0]]],
            "recipe_blueprint-aap1-sr5-75":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-hybrid-processor-empyrian-limited":["resource_convert-module",[[4,0]]],
            "recipe_blueprint-wiz-x-empyrian-s":["resource_convert-module",[[2,0]]],
            "recipe_recipe-test18":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-spc-xu01-empyrian":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-schism-empyrian":["resource_convert-module",[[5,0]]],
            "recipe_blueprint-pet-a-elite-poison":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-tech-amt-1":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-ancient":["resource_convert-module",[[30,0]]],
            "recipe_blueprint-cloakcpu-blacklight":["resource_convert-module",[[3,0]]],
            "recipe_blueprint-hybrid-processor":["resource_convert-module",[[4,0]]],
            "recipe_recipe-test":["resource_convert-module",[[14,0]]],
            "recipe_blueprint-drone-spectrum-blaze":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-agate-bs-2":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-chromin-mindfire-cerebrum":["resource_convert-module",[[35,0]]],
            "recipe_blueprint-micro-trans-empyrian-limited":["resource_convert-module",[[4,0]]],
            "recipe_blueprint-chimera-poison":["resource_convert-module",[[1,0]]],
            "recipe_recipe-test16":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-goliath-x-borealis":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-chromin-quickcoupon":["resource_convert-module",[[5000,0]]],
            "recipe_blueprint-agate-asimov-spectrum":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-chromin-spc-cht01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-fwx-s-valentine":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-spectrum-lava":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-chromin-spectrum-ullrin":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-drone-goliath-x-sandstorm":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-v-lightning":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-agate-evocation-chip-limited":["resource_convert-module",[[100,0]]],
            "recipe_blueprint-drone-spectrum-lava":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-flower-token-acm-1":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-fwx-s-halloween":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-berserker-psyche":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-agate-dmg-npc01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-chromin-hp-cht01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-spc-zpve":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-flower-token-battle-repair-bot":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-hst-2":["resource_convert-module",[[2,0]]],
            "recipe_blueprint-drone-zeus":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-chromin-goliath-plus-ullrin":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-spc-zpve-worldboss":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-chromin-dmg-mtch01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-polychromium-empyrian":["resource_convert-module",[[3000,0]]],
            "recipe_blueprint-indoctrine-accelerator-halloween":["resource_convert-module",[[75,0]]],
            "recipe_blueprint-flower-token-hecate":["resource_convert-module",[[30,0]]],
            "recipe_blueprint-abr-atlas":["resource_convert-module",[[250,0]]],
            "recipe_blueprint-indra-goliath-plus":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-pet-goliath-x-regular":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-drone-spectrum-poison":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-hp-x2":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-ubr-100-50-worldboss":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-indra-venom":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-hp-xa01-atlas":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-champion-ship-mimesis-tyrannos":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-green-booty-key-20":["resource_convert-module",[[21,0]]],
            "recipe_blueprint-spc-x1":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-bastion":["resource_convert-module",[[30,0]]],
            "recipe_blueprint-drone-goliath-x-regular":["resource_convert-module",[[10,0]]],
            "recipe_recipe-test3":["resource_convert-module",[[2,0]]],
            "recipe_blueprint-blue-booty-key":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-champion-ship-disruptor-harbinger":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-chromin-diminisher":["resource_convert-module",[[30,0]]],
            "recipe_blueprint-hp-ham01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-hp-xv01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-flower-token-sab-m01":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-chromin-orcus-ullrin":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-opitite-grt1":["resource_convert-module",[[5,0]]],
            "recipe_blueprint-flower-token-h-nca":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-emp-01":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-agate-unstable-shard-limited":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-module-deflector":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-energy-leech-worldboss":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-extra-energy-empyrian-s":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-chromin-dmg-zep01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-leonov":["resource_convert-module",[[12,0]]],
            "recipe_blueprint-aa1-ubr100-1000":["resource_convert-module",[[5,0]]],
            "recipe_blueprint-dmg-zpve":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-opitite-bt":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-agate-hp-mtch01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-ephon100-blacklight":["resource_convert-module",[[200,0]]],
            "recipe_blueprint-seprom-empyrian-m":["resource_convert-module",[[300,0]]],
            "recipe_recipe-test9":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-drone-xanthos":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-tarnom-lf-4-hp":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-salvage-core-empyrian":["resource_convert-module",[[120,0]]],
            "recipe_blueprint-gop-cc-c-10k":["resource_convert-module",[[100,0]]],
            "recipe_recipe-test12":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-booty-key-empyrian":["resource_convert-module",[[2,0]]],
            "recipe_blueprint-fwx-m-valentine":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-agate-asimov-solace":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-agate-dmg-ret01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-module-laserlr":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-sandstorm-chimera":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-chromin-osmium":["resource_convert-module",[[6000,0]]],
            "recipe_blueprint-spectrum-plus-psyche":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-seprom-halloween":["resource_convert-module",[[10000,0]]],
            "recipe_blueprint-rsb75-blacklight":["resource_convert-module",[[150,0]]],
            "recipe_blueprint-season-paladin-khepri":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-chromin-hecate-ullrin":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-hp-xt10-empyrian":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-season-dmg-xsp01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-season-orcus-viking":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-lf-5":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-champion-drone-diminisher-seraph":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-spc-c01-mm":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-dmg-xv01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-phantom-argon":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-ss-cpu":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-flower-token-mindfire-cerebrum":["resource_convert-module",[[100,0]]],
            "recipe_blueprint-pet10":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-flower-token-bs-2":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-chaos-alien-cpu-legendary":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-agate-tyrannos-disruptor":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-chimera-ocean":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-captain-generic-worldboss":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-hp-holo-10x":["resource_convert-module",[[150,0]]],
            "recipe_blueprint-champion-drone-centurion-harbinger":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-spc-xt10-empyrian":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-speed-burst-valentine":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-ship-liberator-plus":["resource_convert-module",[[100,0]]],
            "recipe_blueprint-champion-drone-sentinel-seraph":["resource_convert-module",[[10,0]]],
            "recipe_recipe-test22":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-diametrion-empyrian-s":["resource_convert-module",[[5,0]]],
            "recipe_blueprint-1hbooster-dmg":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-tech-chainpulse":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-rep-4":["resource_convert-module",[[2,0]]],
            "recipe_blueprint-agate-tyrannos-solace":["resource_convert-module",[[20,0]]],
            "recipe_recipe-test24":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-champion-drone-sentinel-harbinger":["resource_convert-module",[[10,0]]],
            "recipe_recipe-test26":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-season-orcus-thornspire":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-orcus-psyche":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-ddm-01":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-pst-lf-5-al":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-dmg-xa01-atlas":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-tarnom-lf-4":["resource_convert-module",[[6,0]]],
            "recipe_blueprint-dmg-sg01-mm":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-lf-4-md":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-chimera-legend":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-aap1-ubr100-1000":["resource_convert-module",[[5,0]]],
            "recipe_recipe-test30":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-pusat-legend":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-champion-ship-cyborg-tyrannos":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-prismatium-empyrian":["resource_convert-module",[[5,0]]],
            "recipe_blueprint-season-goliath-plus-dogma":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-chaos-alien-cpu-rare":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-chromin-blacklight-trace":["resource_convert-module",[[500,0]]],
            "recipe_blueprint-fs-03":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-pusat-poison":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-goliath-plus-amor":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-season-goliath-plus-dreadwing":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-champion-pet-centurion-seraph":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-ucb-100-5k-valentine":["resource_convert-module",[[50,0]]],
            "recipe_blueprint-booty-key-astral-prime":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-sentinel-frost":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-drive-igd-p":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-candy-spc-sl01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-flower-token-candy-corn":["resource_convert-module",[[250,0]]],
            "recipe_blueprint-flower-token-k-300m":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-seprom":["resource_convert-module",[[5000,0]]],
            "recipe_blueprint-shd-xh01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-chromin-venom-ullrin":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-seprom-empyrian-l":["resource_convert-module",[[600,0]]],
            "recipe_blueprint-goliath-x-ocean":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-flower-token-pld-8":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-sg3n-b00":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-u-lf-4":["resource_convert-module",[[7,0]]],
            "recipe_blueprint-chromin-centurion":["resource_convert-module",[[100,0]]],
            "recipe_blueprint-ai-eco1":["resource_convert-module",[[5,0]]],
            "recipe_blueprint-tarnom-ccg-7500":["resource_convert-module",[[75,0]]],
            "recipe_blueprint-mcb-50":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-goliath-plus-psyche":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-agate-asimov-citadel-plus":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-prismatic-socket":["resource_convert-module",[[2,0]]],
            "recipe_blueprint-borealis-mirage":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-captain-gen1-neo":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-wiz-x-empyrian-m":["resource_convert-module",[[5,0]]],
            "recipe_blueprint-fwx-m-halloween":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-agate-spc-dim01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-tech-backupshield":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-drone-pusat-poison":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-agate-ggeu":["resource_convert-module",[[50,0]]],
            "recipe_blueprint-indra-paladin":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-flower-token-poison-hecate-ship-design":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-spc-xv01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-chromin-dmg-cht01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-seprom-empyrian-limited":["resource_convert-module",[[110,0]]],
            "recipe_blueprint-flower-token-indoctrine-oil":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-flower-token-jump-vouchers":["resource_convert-module",[[5,0]]],
            "recipe_blueprint-flower-token-sr-5":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-hammerclaw":["resource_convert-module",[[24,0]]],
            "recipe_blueprint-season-citadel-plus-viking":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-chromin-solaris-ullrin":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-agate-tyrannos-solace-plus":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-agate-asimov-mimesis":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-agate-tyrannos-centurion":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-spc-x2":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-flower-token-energy-leech":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-2hbooster-rm-b00":["resource_convert-module",[[2,0]]],
            "recipe_blueprint-chromin-berserker":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-bat-green":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-shd-xt10-empyrian-limited":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-ship-hammerclaw-plus":["resource_convert-module",[[100,0]]],
            "recipe_blueprint-hp-bes01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-palladium-empyrian-limited":["resource_convert-module",[[200,0]]],
            "recipe_blueprint-agate-brb-2":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-chaos-alien-cpu-cubikon":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-triskelion":["resource_convert-module",[[100,0]]],
            "recipe_blueprint-pusat-plus-psyche":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-module-damage":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-flower-token-wiz-x":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-champion-pet-centurion-harbinger":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-bat-blue":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-season-solace-plus-enigma":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-booty-key-astral":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-scrapium-atlas":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-pet-pusat-blaze":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-vb-142-10k":["resource_convert-module",[[100,0]]],
            "recipe_blueprint-flower-token-brb-2":["resource_convert-module",[[1,0]]],
            "recipe_recipe-test7":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-flower-token-emp-m01":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-blacklight-cipher":["resource_convert-module",[[100,0]]],
            "recipe_blueprint-candy-phantasm-diminisher":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-ai-r1":["resource_convert-module",[[5,0]]],
            "recipe_blueprint-flower-token-backup-shield":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-chromin-rinusk":["resource_convert-module",[[800,0]]],
            "recipe_blueprint-chromin-zephyr-ullrin":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-tech-backupshield-uridium":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-fwx-l-valentine":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-opitite-ccc-15k":["resource_convert-module",[[150,0]]],
            "recipe_blueprint-extra-energy-valentine":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-polychromium-empyrian-l":["resource_convert-module",[[2500,0]]],
            "recipe_blueprint-borealis-chimera":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-flower-token-h-mt":["resource_convert-module",[[4,0]]],
            "recipe_blueprint-chromin-solace-plus-ullrin":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-chromin-diminisher-ullrin":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-ai-s1":["resource_convert-module",[[5,0]]],
            "recipe_blueprint-sle-04":["resource_convert-module",[[25,0]]],
            "recipe_blueprint-blaze-enigma":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-cnc-lf-5-al":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-indoctrineoil-halloween":["resource_convert-module",[[50,0]]],
            "recipe_blueprint-extra-energy-atlas-s":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-pet-a-elite-ocean":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-drone-a-elite-ocean":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-fwx-com-empyrian":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-champion-ship-orcus-harbinger":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-palladium-empyrian-s":["resource_convert-module",[[150,0]]],
            "recipe_blueprint-module-rocketma":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-agate-asimov-cyborg":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-dmg-xh01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-chromin-berserker-ullrin":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-season-hp-xsp01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-shd-x2":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-spc-spd02":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-season-citadel-plus-samurai":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-lf-4-pd":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-chromin-cyborg":["resource_convert-module",[[32,0]]],
            "recipe_blueprint-tarnom-dmg-dlb":["resource_convert-module",[[100,0]]],
            "recipe_blueprint-tartarus-legend":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-dmg-xt10":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-module-honor":["resource_convert-module",[[1,0]]],
            "recipe_recipe-test21":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-season-orcus-mobius":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-booty-key-silver":["resource_convert-module",[[1,0]]],
            "recipe_blueprint-group-c-atlas":["resource_convert-module",[[30,0]]],
            "recipe_blueprint-wiz-x-empyrian-l":["resource_convert-module",[[10,0]]],
            "recipe_blueprint-aa-1":["resource_convert-module",[[2,0]]],
            "recipe_blueprint-agate-spc-roc01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-agate-hp-npc01":["resource_convert-module",[[15,0]]],
            "recipe_blueprint-tartarus-argon":["resource_convert-module",[[20,0]]],
            "recipe_blueprint-neptune":["resource_convert-module",[[2,0]]],
            "recipe_blueprint-enigma-green":["resource_convert-module",[[10,0]]]
         };
         for(var id:String in settings)
         {
            var r:RecipeAttributes = ItemDataProvider.getItem(id).attributes as RecipeAttributes;
            var values:Array = settings[id] as Array;
            r.costScalingFactor = 1;
            var i:int = 0;
            while(i < r.costs.length)
            {
               var c:RecipeCosts = r.costs[i];
               c.parts = new Vector.<BuildPart>();
               var part:BuildPart = new BuildPart();
               part.lootID = values[0];
               part.ammount = values[1][i][0];
               c.parts.push(part);
               c.skipCosts = new Vector.<BuildPart>();
               if(values[1][i][1] > 0)
               {
                  part = new BuildPart();
                  part.lootID = values[0];
                  part.ammount = values[1][i][1];
                  c.skipCosts.push(part);
               }
               i++;
            }
         }
      }
      
      public function get currentRecipes() : Vector.<AssemblyRecipeModel>
      {
         return this._currentRecipes;
      }
      
      public function update(param1:AssemblyRecipeModule) : void
      {
         var _loc2_:AssemblyRecipeModel = this.getOrAdd(param1);
         if(!_loc2_)
         {
            return;
         }
         _loc2_.state = this.createState(param1.status);
         _loc2_.type = this.createType(param1.type);
         this.sortModel();
      }
      
      public function sortModel() : void
      {
         this._currentRecipes.sort(AssemblyRecipeModel.sort);
      }
      
      public function updateStatus(param1:AssemblyRecipeStatusUpdateCommand) : void
      {
         var _loc2_:AssemblyRecipeModel = this.getById(param1.lootId,param1.targetItemId);
         if(_loc2_)
         {
            _loc2_.state = this.createState(param1.status);
         }
         this.sortModel();
      }
      
      public function removeRecipes(param1:Vector.<AssemblyRecipeKeyModule>) : void
      {
         var _loc4_:AssemblyRecipeModel = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:AssemblyRecipeKeyModule = null;
         var _loc2_:int = int(this._currentRecipes.length);
         var _loc3_:* = int(_loc2_ - 1);
         while(_loc3_ >= 0)
         {
            _loc4_ = this._currentRecipes[_loc3_];
            _loc5_ = int(param1.length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = param1[_loc6_];
               if(_loc4_.lootId == _loc7_.lootId && _loc4_.targetId == _loc7_.targetId)
               {
                  this.internalRemove(_loc4_);
                  break;
               }
               _loc6_++;
            }
            _loc3_--;
         }
      }
      
      public function getByTargetId(param1:Number) : AssemblyRecipeModel
      {
         var _loc4_:AssemblyRecipeModel = null;
         var _loc2_:int = int(this._currentRecipes.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._currentRecipes[_loc3_];
            if(_loc4_.targetId == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function getByTargetIdAndLootID(param1:int, param2:String) : AssemblyRecipeModel
      {
         var _loc5_:AssemblyRecipeModel = null;
         var _loc3_:int = int(this._currentRecipes.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this._currentRecipes[_loc4_];
            if(_loc5_.targetId == param1 && _loc5_.lootId == param2)
            {
               return _loc5_;
            }
            _loc4_++;
         }
         return null;
      }
      
      public function cleanup() : void
      {
         var _loc3_:AssemblyRecipeModel = null;
         var _loc1_:int = int(this._currentRecipes.length);
         var _loc2_:* = int(_loc1_ - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = this._currentRecipes[_loc2_];
            this.internalRemove(_loc3_);
            _loc2_--;
         }
      }
      
      private function internalRemove(param1:AssemblyRecipeModel) : void
      {
         param1.isBuildAbleOnce.remove(this.buildWarning.dispatch);
         var _loc2_:int = this._currentRecipes.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._currentRecipes.splice(_loc2_,1);
         }
         this.recipeRemoved.dispatch(param1);
      }
      
      private function createType(param1:AssemblyRecipeTypeModule) : AbstractAssemblyType
      {
         return new (_type2Class[param1.getLibcomModuleId()] || AbstractAssemblyType)(param1);
      }
      
      private function createState(param1:AssemblyRecipeStatusModule) : AbstractAssemblyState
      {
         if(param1 is AssemblyRecipeBuildStatusModule)
         {
            return new AssemblyTimerState(param1 as AssemblyRecipeBuildStatusModule);
         }
         if(param1 is AssemblyRecipeAvailableStatusModule)
         {
            return new AssemblyAvailableState(param1 as AssemblyRecipeAvailableStatusModule);
         }
         if(param1 is AssemblyRecipeReadyToCollectStatusModule)
         {
            this.buildWarning.dispatch();
         }
         return new AbstractAssemblyState(param1);
      }
      
      private function getOrAdd(param1:AssemblyRecipeModule) : AssemblyRecipeModel
      {
         var _loc2_:AssemblyRecipeModel = this.getById(param1.recipeLootId,param1.targetItemId);
         if(!_loc2_)
         {
            _loc2_ = this.createRecipe(param1);
            if(!_loc2_)
            {
               return null;
            }
            _loc2_.isBuildAbleOnce.add(this.buildWarning.dispatch);
            this.writeIngredients(_loc2_);
            this._currentRecipes.push(_loc2_);
            setTimeout(this.recipeAdded.dispatch,1,_loc2_);
         }
         return _loc2_;
      }
      
      private function createRecipe(param1:AssemblyRecipeModule) : AssemblyRecipeModel
      {
         var recipeAttr:RecipeAttributes = null;
         var data:AssemblyRecipeModule = param1;
         try
         {
            recipeAttr = ItemDataProvider.getItem(data.recipeLootId).attributes as RecipeAttributes;
            if(recipeAttr.targets.length > 0)
            {
               if(StringUtils.startsWith(recipeAttr.lootId,AssemblyConsts.UPGRADE_PREFIX))
               {
                  return new UpgraderecipeModel(ItemDataProviderHelper.getItem(data.recipeLootId),this.getItems(recipeAttr.result),data.targetItemId);
               }
               if(StringUtils.startsWith(recipeAttr.lootId,AssemblyConsts.DISASSEBLY_PREFIX))
               {
                  return new DisassemblyRecipeModel(ItemDataProviderHelper.getItem(data.recipeLootId),this.getItems(recipeAttr.result),data.targetItemId);
               }
            }
            return new AssemblyRecipeModel(ItemDataProviderHelper.getItem(data.recipeLootId),this.getItems(recipeAttr.result),data.targetItemId);
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      private function getItems(param1:Vector.<BuildPart>) : Vector.<ItemVO>
      {
         var _loc5_:BuildPart = null;
         var _loc6_:ItemVO = null;
         var _loc2_:Vector.<ItemVO> = new Vector.<ItemVO>(0);
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            _loc6_ = ItemDataProviderHelper.getItem(_loc5_.lootID);
            _loc6_.amount = _loc5_.ammount;
            _loc2_.push(_loc6_);
            _loc4_++;
         }
         return _loc2_;
      }
      
      private function writeIngredients(param1:AssemblyRecipeModel) : void
      {
         var _loc5_:RecipeCosts = null;
         var _loc6_:Vector.<BuildPart> = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:BuildPart = null;
         var _loc12_:BuildPart = null;
         var _loc2_:RecipeAttributes = ItemDataProvider.getItem(param1.lootId).attributes as RecipeAttributes;
         var _loc3_:int = int(_loc2_.costs.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_.costs[_loc4_];
            _loc6_ = _loc5_.parts;
            _loc7_ = int(_loc6_.length);
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc11_ = _loc6_[_loc8_];
               param1.setIngredient(new AssemblyLootCount(ItemDataProviderHelper.getItem(_loc11_.lootID),_loc11_.ammount,ItemDataProviderHelper.getAmountWithDiscount(_loc11_.lootID,_loc11_.ammount,param1.source)));
               _loc8_++;
            }
            _loc9_ = int(_loc5_.skipCosts.length);
            _loc10_ = 0;
            while(_loc10_ < _loc9_)
            {
               _loc12_ = _loc5_.skipCosts[_loc10_];
               param1.setIngredient(new AssemblyLootCount(ItemDataProviderHelper.getItem(_loc12_.lootID),_loc12_.ammount,ItemDataProviderHelper.getAmountWithDiscount(_loc12_.lootID,_loc12_.ammount,param1.source)));
               _loc10_++;
            }
            _loc4_++;
         }
      }
      
      private function getById(param1:String, param2:Number) : AssemblyRecipeModel
      {
         var _loc5_:AssemblyRecipeModel = null;
         var _loc3_:int = int(this._currentRecipes.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this._currentRecipes[_loc4_];
            if(_loc5_.lootId == param1 && _loc5_.targetId == param2)
            {
               return _loc5_;
            }
            _loc4_++;
         }
         return null;
      }
   }
}

