package net.bigpoint.darkorbit.mvc.crafting.reroll.model
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.bigpoint.utils.bindables.BindableInt;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.com.module.RerollWindowSettingsModule;
   import net.bigpoint.darkorbit.com.module.UnstableModuleModule;
   import net.bigpoint.darkorbit.com.module.UnstableModuleRecycleResultCommand;
   import net.bigpoint.darkorbit.com.module.UnstableModulesListCommand;
   import net.bigpoint.darkorbit.com.module.UnstableModulesShardCommand;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class RerollUIData
   {
      
      private const DMG_KEY:String = "equipment_shipupgrade_dmg";
      
      private const HP_KEY:String = "equipment_shipupgrade_hp";
      
      private const SHD_KEY:String = "equipment_shipupgrade_shd";
      
      private const SPC_KEY:String = "equipment_shipupgrade_spc";
      
      private const CANNON_KEY:String = "equipment_weapon_cannon";
      
      private const CANNON_SHIELD_KEY:String = "equipment_cannon_shield";
      
      public const onListChanged:ISignal = new Signal();
      
      public var rerollModel:Dictionary = new Dictionary();
      
      public var unstableShard:BindableInt = new BindableInt();
      
      public var unstableChipShard:BindableInt = new BindableInt();
      
      public var dontShowPopup:Boolean;
      
      public var restabilizePending:Boolean;
      
      public var discountEvent:BindableBoolean = new BindableBoolean();
      
      public function RerollUIData()
      {
         super();
      }
      
      public function updateInfo(param1:UnstableModulesListCommand) : void
      {
         this.rerollModel[RerollTypeModel.TYPE_DMG] = new RerollTypeModel(RerollTypeModel.TYPE_DMG);
         this.rerollModel[RerollTypeModel.TYPE_HP] = new RerollTypeModel(RerollTypeModel.TYPE_HP);
         this.rerollModel[RerollTypeModel.TYPE_SHD] = new RerollTypeModel(RerollTypeModel.TYPE_SHD);
         this.rerollModel[RerollTypeModel.TYPE_SPC] = new RerollTypeModel(RerollTypeModel.TYPE_SPC);
         this.rerollModel[RerollTypeModel.TYPE_CANNON] = new RerollTypeModel(RerollTypeModel.TYPE_CANNON);
         this.rerollModel[RerollTypeModel.TYPE_CANNON_SHIELD] = new RerollTypeModel(RerollTypeModel.TYPE_CANNON_SHIELD);
         var _loc2_:Vector.<UnstableModuleModule> = param1.allModules;
         var _loc3_:RerollTypeModel = null;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(_loc2_[_loc4_].lootId.indexOf(this.DMG_KEY) >= 0)
            {
               _loc3_ = this.rerollModel[RerollTypeModel.TYPE_DMG] as RerollTypeModel;
               _loc3_.addRerollList(_loc2_[_loc4_]);
            }
            else if(_loc2_[_loc4_].lootId.indexOf(this.HP_KEY) >= 0)
            {
               _loc3_ = this.rerollModel[RerollTypeModel.TYPE_HP] as RerollTypeModel;
               _loc3_.addRerollList(_loc2_[_loc4_]);
            }
            else if(_loc2_[_loc4_].lootId.indexOf(this.SHD_KEY) >= 0)
            {
               _loc3_ = this.rerollModel[RerollTypeModel.TYPE_SHD] as RerollTypeModel;
               _loc3_.addRerollList(_loc2_[_loc4_]);
            }
            else if(_loc2_[_loc4_].lootId.indexOf(this.SPC_KEY) >= 0)
            {
               _loc3_ = this.rerollModel[RerollTypeModel.TYPE_SPC] as RerollTypeModel;
               _loc3_.addRerollList(_loc2_[_loc4_]);
            }
            else if(_loc2_[_loc4_].lootId.indexOf(this.CANNON_KEY) >= 0)
            {
               _loc3_ = this.rerollModel[RerollTypeModel.TYPE_CANNON] as RerollTypeModel;
               _loc3_.addRerollList(_loc2_[_loc4_]);
            }
            else if(_loc2_[_loc4_].lootId.indexOf(this.CANNON_SHIELD_KEY) >= 0)
            {
               _loc3_ = this.rerollModel[RerollTypeModel.TYPE_CANNON_SHIELD] as RerollTypeModel;
               _loc3_.addRerollList(_loc2_[_loc4_]);
            }
            _loc4_++;
         }
         this.unstableShard.value = param1.shardCommand.shardsLeft;
         this.unstableChipShard.value = param1.shardCommand.chipLeft;
         this.discountEvent.value = param1.isDiscountRunning;
         if(this.restabilizePending && param1.resetUI)
         {
            this.restabilizePending = false;
         }
         this.onListChanged.dispatch();
      }
      
      public function updateModuleInfo(param1:UnstableModuleModule) : void
      {
         var _loc2_:RerollTypeModel = null;
         for each(_loc2_ in this.rerollModel)
         {
            _loc2_.replaceRerollList(param1);
         }
         this.restabilizePending = false;
         this.onListChanged.dispatch();
      }
      
      public function updateShardsAmount(param1:UnstableModulesShardCommand) : void
      {
         this.unstableShard.value = param1.shardsLeft;
         this.unstableChipShard.value = param1.chipLeft;
      }
      
      public function updateRecycleResult(param1:UnstableModuleRecycleResultCommand) : void
      {
         var _loc2_:RerollTypeModel = null;
         this.unstableShard.value = param1.shardCommand.shardsLeft;
         this.unstableChipShard.value = param1.shardCommand.chipLeft;
         for each(_loc2_ in this.rerollModel)
         {
            _loc2_.removeRerollList(param1.itemId);
         }
         this.onListChanged.dispatch();
      }
      
      public function updateRerollWindowSettings(param1:RerollWindowSettingsModule) : void
      {
         this.dontShowPopup = param1.rerollPopupSettings;
      }
   }
}

