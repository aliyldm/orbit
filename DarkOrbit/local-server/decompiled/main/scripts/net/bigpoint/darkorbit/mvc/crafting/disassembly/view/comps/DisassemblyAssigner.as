package net.bigpoint.darkorbit.mvc.crafting.disassembly.view.comps
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.ReplacementTypeModule;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.items.item.traits.StackableTrait;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.common.utils.TextUtils;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyLootCount;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.view.ui.IngredientAssigner;
   
   public class DisassemblyAssigner extends IngredientAssigner
   {
      
      private var _warning:Coreponent;
      
      public function DisassemblyAssigner()
      {
         super();
      }
      
      override protected function getTotal(param1:AssemblyLootCount) : Number
      {
         return -param1.total;
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._warning = FuiComponentSelectorUtil.selectComponent("content.warning",this) as Coreponent;
      }
      
      override protected function update() : void
      {
         var _loc1_:AssemblyLootCount = data as AssemblyLootCount;
         if(!_loc1_)
         {
            return;
         }
         loadResource(_loc1_.itemVO.getLoot30x30(),handleLoadComplete,handleLoadFail,AssetsProxy.ITEMS);
         _name.text = TextUtils.getTranslationByType(_loc1_.lootId,ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_CODE);
         var _loc2_:StackableTrait = _loc1_.itemVO.getTraitByType(StackableTrait.TYPE) as StackableTrait;
         var _loc3_:Number = this.getTotal(_loc1_);
         if(Boolean(_loc2_) && _loc2_.maxQuantity < _loc1_.count.value + _loc3_)
         {
            _amount.text = Math.max(_loc2_.maxQuantity - _loc1_.count.value,0) + "/" + _loc3_;
            this._warning.visible = true;
            _help.visible = false;
            this._warning.tooltipData = BPLocale.getItem("assembly_label_maximum_quantity_exeeded");
         }
         else
         {
            _amount.text = _loc3_.toString();
            this._warning.visible = false;
            _help.visible = true;
            _help.tooltipData = _loc1_.itemVO.sourceName;
         }
      }
   }
}

