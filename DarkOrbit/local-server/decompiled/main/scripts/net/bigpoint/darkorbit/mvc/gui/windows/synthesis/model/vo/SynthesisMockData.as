package net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model.vo
{
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipEquipmentInventoryItem;
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisCostLootCommand;
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisGroupCommand;
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisInventoryCommand;
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisListCommand;
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisModuleCommand;
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisModuleListCommand;
   
   public class SynthesisMockData
   {
      
      private static var _instance:SynthesisMockData;
      
      private static const MOCK_CANNON_STAR_GROUP:String = "cannonStarUp";
      
      private static const MOCK_CANNON_STAR_BUTTON:String = "synthesis_cannon_star_promote";
      
      private static const CANNON_STAR_LIST_ROWS:Array = [["Synthesis_table_2","helios"],["Synthesis_table_3","indra"],["Synthesis_table_1","nidhogg"]];
      
      private static const CANNON_STAR_SUFFIXES:Array = ["citadel-plus","cyborg","diminisher","goliath-plus","hammerclaw-plus","hyperion","orcus","paladin","pusat-plus","retiarus-plus","solace-plus","solaris-plus","spearhead-plus","spectrum-plus","venom"];
      
      private static const CANNON_STAR_INPUT_COUNT:int = 2;
      
      private static const CANNON_STAR_CURRENCY_AMOUNT:int = 10000;
      
      private static const CANNON_ROWS:Array = [["Synthesis_table_2","equipment_weapon_cannon_ep-helios",0,"equipment_weapon_cannon_r-helios",5,null,1000],["Synthesis_table_3","equipment_weapon_cannon_ep-indra",0,"equipment_weapon_cannon_r-indra",5,null,1000],["Synthesis_table_1","equipment_weapon_cannon_ep-nidhogg",0,"equipment_weapon_cannon_r-nidhogg",5,null,1000],["Synthesis_table_2","equipment_weapon_cannon_ma-helios",0,"equipment_weapon_cannon_ep-helios",5,null,2000],["Synthesis_table_3","equipment_weapon_cannon_ma-indra",0,"equipment_weapon_cannon_ep-indra",5,null,2000],["Synthesis_table_1","equipment_weapon_cannon_ma-nidhogg",0,"equipment_weapon_cannon_ep-nidhogg",5,null,2000],["Synthesis_table_2","equipment_weapon_cannon_leg-helios",0,"equipment_weapon_cannon_ma-helios",5,null,5000],["Synthesis_table_3","equipment_weapon_cannon_leg-indra",0,"equipment_weapon_cannon_ma-indra",5,null,5000],["Synthesis_table_1","equipment_weapon_cannon_leg-nidhogg",0,"equipment_weapon_cannon_ma-nidhogg",5
      ,null,5000],["Synthesis_table_1","equipment_weapon_cannon_ul-nidhogg-pusat-plus",534,"equipment_weapon_cannon_leg-nidhogg",4,"resource_collectable_energy-nidhogg-pusat-plus",10000],["Synthesis_table_2","equipment_weapon_cannon_ul-helios-pusat-plus",534,"equipment_weapon_cannon_leg-helios",4,"resource_collectable_energy-helios-pusat-plus",10000],["Synthesis_table_1","equipment_weapon_cannon_ul-nidhogg-diminisher",64,"equipment_weapon_cannon_leg-nidhogg",4,"resource_collectable_energy-nidhogg-diminisher",10000],["Synthesis_table_2","equipment_weapon_cannon_ul-helios-diminisher",64,"equipment_weapon_cannon_leg-helios",4,"resource_collectable_energy-helios-diminisher",10000],["Synthesis_table_1","equipment_weapon_cannon_ul-nidhogg-cyborg",245,"equipment_weapon_cannon_leg-nidhogg",4,"resource_collectable_energy-nidhogg-cyborg",10000],["Synthesis_table_2","equipment_weapon_cannon_ul-helios-cyborg",245,"equipment_weapon_cannon_leg-helios",4,"resource_collectable_energy-helios-cyborg",10000],["Synthesis_table_1"
      ,"equipment_weapon_cannon_ul-nidhogg-venom",67,"equipment_weapon_cannon_leg-nidhogg",4,"resource_collectable_energy-nidhogg-venom",10000],["Synthesis_table_2","equipment_weapon_cannon_ul-helios-venom",67,"equipment_weapon_cannon_leg-helios",4,"resource_collectable_energy-helios-venom",10000],["Synthesis_table_1","equipment_weapon_cannon_ul-nidhogg-citadel-plus",507,"equipment_weapon_cannon_leg-nidhogg",4,"resource_collectable_energy-nidhogg-citadel-plus",10000],["Synthesis_table_2","equipment_weapon_cannon_ul-helios-citadel-plus",507,"equipment_weapon_cannon_leg-helios",4,"resource_collectable_energy-helios-citadel-plus",10000],["Synthesis_table_1","equipment_weapon_cannon_ul-nidhogg-spearhead-plus",563,"equipment_weapon_cannon_leg-nidhogg",4,"resource_collectable_energy-nidhogg-spearhead-plus",10000],["Synthesis_table_2","equipment_weapon_cannon_ul-helios-spearhead-plus",563,"equipment_weapon_cannon_leg-helios",4,"resource_collectable_energy-helios-spearhead-plus",10000],["Synthesis_table_1"
      ,"equipment_weapon_cannon_ul-nidhogg-solace-plus",527,"equipment_weapon_cannon_leg-nidhogg",4,"resource_collectable_energy-nidhogg-solace-plus",10000],["Synthesis_table_2","equipment_weapon_cannon_ul-helios-solace-plus",527,"equipment_weapon_cannon_leg-helios",4,"resource_collectable_energy-helios-solace-plus",10000],["Synthesis_table_1","equipment_weapon_cannon_ul-nidhogg-goliath-plus",506,"equipment_weapon_cannon_leg-nidhogg",4,"resource_collectable_energy-nidhogg-goliath-plus",10000],["Synthesis_table_2","equipment_weapon_cannon_ul-helios-goliath-plus",506,"equipment_weapon_cannon_leg-helios",4,"resource_collectable_energy-helios-goliath-plus",10000],["Synthesis_table_1","equipment_weapon_cannon_ul-nidhogg-orcus",446,"equipment_weapon_cannon_leg-nidhogg",4,"resource_collectable_energy-nidhogg-orcus",10000],["Synthesis_table_2","equipment_weapon_cannon_ul-helios-orcus",446,"equipment_weapon_cannon_leg-helios",4,"resource_collectable_energy-helios-orcus",10000],["Synthesis_table_1","equipment_weapon_cannon_ul-nidhogg-solaris-plus"
      ,528,"equipment_weapon_cannon_leg-nidhogg",4,"resource_collectable_energy-nidhogg-solaris-plus",10000],["Synthesis_table_2","equipment_weapon_cannon_ul-helios-solaris-plus",528,"equipment_weapon_cannon_leg-helios",4,"resource_collectable_energy-helios-solaris-plus",10000],["Synthesis_table_1","equipment_weapon_cannon_ul-nidhogg-hammerclaw-plus",550,"equipment_weapon_cannon_leg-nidhogg",4,"resource_collectable_energy-nidhogg-hammerclaw-plus",10000],["Synthesis_table_2","equipment_weapon_cannon_ul-helios-hammerclaw-plus",550,"equipment_weapon_cannon_leg-helios",4,"resource_collectable_energy-helios-hammerclaw-plus",10000],["Synthesis_table_1","equipment_weapon_cannon_ul-nidhogg-spectrum-plus",611,"equipment_weapon_cannon_leg-nidhogg",4,"resource_collectable_energy-nidhogg-spectrum-plus",10000],["Synthesis_table_2","equipment_weapon_cannon_ul-helios-spectrum-plus",611,"equipment_weapon_cannon_leg-helios",4,"resource_collectable_energy-helios-spectrum-plus",10000],["Synthesis_table_1","equipment_weapon_cannon_ul-nidhogg-paladin"
      ,674,"equipment_weapon_cannon_leg-nidhogg",4,"resource_collectable_energy-nidhogg-paladin",10000],["Synthesis_table_2","equipment_weapon_cannon_ul-helios-paladin",674,"equipment_weapon_cannon_leg-helios",4,"resource_collectable_energy-helios-paladin",10000],["Synthesis_table_1","equipment_weapon_cannon_ul-nidhogg-retiarus-plus",706,"equipment_weapon_cannon_leg-nidhogg",4,"resource_collectable_energy-nidhogg-retiarus-plus",10000],["Synthesis_table_2","equipment_weapon_cannon_ul-helios-retiarus-plus",706,"equipment_weapon_cannon_leg-helios",4,"resource_collectable_energy-helios-retiarus-plus",10000],["Synthesis_table_2","equipment_weapon_cannon_ul-helios-hyperion",724,"equipment_weapon_cannon_leg-helios",4,"resource_collectable_energy-helios-hyperion",10000],["Synthesis_table_1","equipment_weapon_cannon_ul-nidhogg-hyperion",724,"equipment_weapon_cannon_leg-nidhogg",4,"resource_collectable_energy-nidhogg-hyperion",10000]];
      
      private static const DRIVE_ROWS:Array = [["Synthesis_drive_1","equipment_weapon_drive_igd-l02",0,"equipment_weapon_drive_igd-l01",5,null,1000],["Synthesis_drive_1","equipment_weapon_drive_igd-p",0,"equipment_weapon_drive_igd-l02",5,null,1000],["Synthesis_drive_2","equipment_lens_gl-omega",0,"equipment_lens_gl-chron",5,null,1000]];
      
      public function SynthesisMockData()
      {
         super();
      }
      
      public static function getInstance() : SynthesisMockData
      {
         if(!_instance)
         {
            _instance = new SynthesisMockData();
         }
         return _instance;
      }
      
      public function createListCommand() : SynthesisListCommand
      {
         var _loc4_:Array = null;
         var _loc5_:Vector.<SynthesisModuleListCommand> = null;
         var _loc1_:Vector.<SynthesisGroupCommand> = new Vector.<SynthesisGroupCommand>();
         var _loc2_:Vector.<SynthesisModuleListCommand> = new Vector.<SynthesisModuleListCommand>();
         _loc2_.push(new SynthesisModuleListCommand("",this.createRows(CANNON_ROWS)));
         _loc1_.push(new SynthesisGroupCommand("Synthesis_cannon_button","Synthesis_button",_loc2_));
         var _loc3_:Vector.<SynthesisModuleListCommand> = new Vector.<SynthesisModuleListCommand>();
         for each(_loc4_ in CANNON_STAR_LIST_ROWS)
         {
            _loc3_.push(new SynthesisModuleListCommand(String(_loc4_[0]),this.createStarModules(String(_loc4_[1]))));
         }
         _loc1_.push(new SynthesisGroupCommand(MOCK_CANNON_STAR_GROUP,MOCK_CANNON_STAR_BUTTON,_loc3_));
         _loc5_ = new Vector.<SynthesisModuleListCommand>();
         _loc5_.push(new SynthesisModuleListCommand("",this.createRows(DRIVE_ROWS)));
         _loc1_.push(new SynthesisGroupCommand("Synthesis_drive_button","Synthesis_button",_loc5_));
         return new SynthesisListCommand(_loc1_);
      }
      
      public function createInventoryCommand() : SynthesisInventoryCommand
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc1_:Vector.<HangarShipEquipmentInventoryItem> = new Vector.<HangarShipEquipmentInventoryItem>();
         var _loc2_:Number = 980000000;
         var _loc3_:Object = {};
         this.collectCertainAmounts(CANNON_ROWS,_loc3_);
         this.collectCertainAmounts(DRIVE_ROWS,_loc3_);
         for(_loc4_ in _loc3_)
         {
            _loc2_ = this.appendInventoryItems(_loc1_,_loc2_,_loc4_,int(_loc3_[_loc4_]),0);
         }
         for each(_loc5_ in CANNON_STAR_LIST_ROWS)
         {
            _loc2_ = this.appendStarInventoryItems(_loc1_,_loc2_,String(_loc5_[1]));
         }
         return new SynthesisInventoryCommand(_loc1_,false);
      }
      
      private function collectCertainAmounts(param1:Array, param2:Object) : void
      {
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         for each(_loc3_ in param1)
         {
            _loc4_ = String(_loc3_[3]);
            _loc5_ = param2[_loc4_] ? int(param2[_loc4_]) : 0;
            param2[_loc4_] = Math.max(_loc5_,int(_loc3_[4]));
         }
      }
      
      private function appendInventoryItems(param1:Vector.<HangarShipEquipmentInventoryItem>, param2:Number, param3:String, param4:int, param5:int) : Number
      {
         var _loc6_:int = 0;
         while(_loc6_ < param4)
         {
            param1.push(new HangarShipEquipmentInventoryItem(param2++,param3,0,1,"","",0,param5));
            _loc6_++;
         }
         return param2;
      }
      
      private function appendStarInventoryItems(param1:Vector.<HangarShipEquipmentInventoryItem>, param2:Number, param3:String) : Number
      {
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc4_:int = 1;
         while(_loc4_ <= 5)
         {
            _loc5_ = _loc4_ - 1;
            for each(_loc6_ in CANNON_STAR_SUFFIXES)
            {
               _loc7_ = "equipment_weapon_cannon_ul-" + param3 + "-" + _loc6_;
               param2 = this.appendInventoryItems(param1,param2,_loc7_,CANNON_STAR_INPUT_COUNT,_loc5_);
            }
            _loc4_++;
         }
         return param2;
      }
      
      private function createRows(param1:Array) : Vector.<SynthesisModuleCommand>
      {
         var _loc3_:Array = null;
         var _loc4_:Vector.<SynthesisCostLootCommand> = null;
         var _loc5_:int = 0;
         var _loc2_:Vector.<SynthesisModuleCommand> = new Vector.<SynthesisModuleCommand>();
         for each(_loc3_ in param1)
         {
            _loc4_ = new Vector.<SynthesisCostLootCommand>();
            _loc5_ = 0;
            while(_loc5_ < int(_loc3_[4]))
            {
               _loc4_.push(new SynthesisCostLootCommand(String(_loc3_[3]),1,true,0));
               _loc5_++;
            }
            if(_loc3_[5])
            {
               _loc4_.push(new SynthesisCostLootCommand(String(_loc3_[5]),1,false,0));
            }
            _loc4_.push(new SynthesisCostLootCommand("currency_uridium",int(_loc3_[6]),false,0));
            _loc2_.push(new SynthesisModuleCommand(String(_loc3_[1]),int(_loc3_[2]),_loc4_,String(_loc3_[0]),0));
         }
         return _loc2_;
      }
      
      private function createStarModules(param1:String) : Vector.<SynthesisModuleCommand>
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Vector.<SynthesisCostLootCommand> = null;
         var _loc2_:Vector.<SynthesisModuleCommand> = new Vector.<SynthesisModuleCommand>();
         var _loc3_:int = 1;
         while(_loc3_ <= 5)
         {
            _loc4_ = "synthesis_cannon_type_star" + _loc3_;
            for each(_loc5_ in CANNON_STAR_SUFFIXES)
            {
               _loc6_ = "equipment_weapon_cannon_ul-" + param1 + "-" + _loc5_;
               _loc7_ = new Vector.<SynthesisCostLootCommand>();
               _loc7_.push(new SynthesisCostLootCommand(_loc6_,1,true,_loc3_ - 1));
               _loc7_.push(new SynthesisCostLootCommand(_loc6_,1,true,_loc3_ - 1));
               _loc7_.push(new SynthesisCostLootCommand("currency_uridium",CANNON_STAR_CURRENCY_AMOUNT,false,0));
               _loc2_.push(new SynthesisModuleCommand(_loc6_,0,_loc7_,_loc4_,_loc3_));
            }
            _loc3_++;
         }
         return _loc2_;
      }
   }
}

