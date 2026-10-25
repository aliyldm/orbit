package net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.view.assigners
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.bindables.BindableNumber;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.ReplacementTypeModule;
   import net.bigpoint.darkorbit.mvc.common.utils.TextUtils;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyLootCount;
   import net.bigpoint.darkorbit.utils.HtmlTextUtils;
   
   public class SingularityDriveSkipCostAssigner extends SingularityDriveCostAssigner
   {
      
      public static const costFactor:BindableNumber = new BindableNumber(1,0.01,1);
      
      public function SingularityDriveSkipCostAssigner()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         costFactor.changed.remove(this.updatePercentage);
         super.data = param1;
         if(param1 is AssemblyLootCount)
         {
            costFactor.changed.add(this.updatePercentage);
         }
      }
      
      override protected function update() : void
      {
         super.update();
         this.updatePercentage();
      }
      
      override public function dispose() : void
      {
         costFactor.changed.remove(this.updatePercentage);
         super.dispose();
      }
      
      private function updatePercentage() : void
      {
         var _loc1_:AssemblyLootCount = data as AssemblyLootCount;
         if(!_loc1_)
         {
            return;
         }
         var _loc2_:int = Math.round(_loc1_.total * costFactor.value);
         var _loc3_:Number = _loc1_.count.value;
         var _loc4_:Boolean = _loc3_ < _loc2_;
         var _loc5_:String = TextFormatter.roundInteger(_loc3_);
         if(_loc4_)
         {
            _loc5_ = HtmlTextUtils.coloriseText(16711680,_loc5_);
         }
         _ownedAmount.text = _loc5_ + " /";
         _amount.text = TextFormatter.roundInteger(_loc2_);
         _name.text = TextUtils.getTranslationByType(_loc1_.lootId,ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_CODE);
         var _loc6_:String = TextFormatter.roundInteger(_loc3_) + " / " + TextFormatter.roundInteger(_loc2_);
         if(_loc4_)
         {
            _loc6_ += "\n" + HtmlTextUtils.coloriseText(16711680,BPLocale.getItem("crafting_tooltip_insufficient_amount"));
         }
         tooltipData = _loc6_;
      }
   }
}

