package net.bigpoint.darkorbit.mvc.crafting.reroll.view.components.listAssigners
{
   import com.bigpoint.utils.TextFormatter;
   import flash.display.Bitmap;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyLootCount;
   import net.bigpoint.darkorbit.utils.HtmlTextUtils;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class RerollResultRetainCostGridAssigner extends DefaultItemDataAssigner
   {
      
      private var _img:Coreponent;
      
      private var _hover:Button;
      
      private var _name:Label;
      
      private var _amount:Label;
      
      public function RerollResultRetainCostGridAssigner()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         if(param1 == data)
         {
            super.data = param1;
         }
         else
         {
            this.removeCallbacks();
            super.data = param1;
            if(param1)
            {
               this.update(param1 as AssemblyLootCount);
            }
         }
      }
      
      private function get dataVO() : AssemblyLootCount
      {
         return data as AssemblyLootCount;
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._img = FuiComponentSelectorUtil.selectComponent("img",this) as Coreponent;
         this._name = FuiComponentSelectorUtil.selectComponent("item_name",this) as Label;
         this._amount = FuiComponentSelectorUtil.selectComponent("item_amt",this) as Label;
         this._hover = FuiComponentSelectorUtil.selectComponent("help",this) as Button;
      }
      
      override protected function drawSelection() : void
      {
         super.drawSelection();
         if(this._hover != null)
         {
            this._hover.enabled = !_selected;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
      
      private function removeCallbacks() : void
      {
         if(!this.dataVO)
         {
            return;
         }
         var _loc1_:ItemVO = ItemDataProviderHelper.getItem(this.dataVO.lootId);
         if(_loc1_)
         {
            removeLoadResourceCallback(_loc1_.getLoot30x30(),this.handleItemLoaded,AssetsProxy.ITEMS);
         }
      }
      
      private function update(param1:AssemblyLootCount) : void
      {
         var _loc7_:String = null;
         if(!this.dataVO)
         {
            return;
         }
         var _loc2_:ItemVO = ItemDataProviderHelper.getItem(this.dataVO.lootId);
         if(!_loc2_)
         {
            return;
         }
         tooltipData = _loc2_.sourceName;
         var _loc3_:String = _loc2_.getLoot30x30(Hero.factionName);
         loadResource(_loc3_,this.handleItemLoaded,this.handleItemLoadError,AssetsProxy.ITEMS);
         this._name.text = _loc2_.fullname;
         var _loc4_:Number = param1.count.value;
         var _loc5_:Number = param1.total;
         var _loc6_:Boolean = _loc4_ < _loc5_;
         if(_loc6_)
         {
            _loc7_ = HtmlTextUtils.coloriseText(16711680,TextFormatter.roundInteger(_loc4_));
         }
         else
         {
            _loc7_ = TextFormatter.roundInteger(_loc4_);
         }
         if(!isNaN(_loc4_))
         {
            _loc7_ += " /";
         }
         _loc7_ += TextFormatter.roundInteger(_loc5_);
         this._amount.text = _loc7_;
      }
      
      private function handleItemLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
      }
      
      private function handleItemLoaded(param1:ImageFinisher = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
         var _loc2_:Bitmap = new Bitmap(param1.getBitmap().bitmapData);
         this._img.addChild(_loc2_);
      }
   }
}

