package net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.utils
{
   import flash.display.Bitmap;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class WorldBossDataAssigner extends DefaultItemDataAssigner
   {
      
      protected var _bg:Coreponent;
      
      protected var _completion:Label;
      
      protected var _itemAIcon:Button;
      
      protected var _itemAAmount:Label;
      
      protected var _itemBIcon:Button;
      
      protected var _itemBAmount:Label;
      
      protected var _itemCIcon:Button;
      
      protected var _itemCAmount:Label;
      
      protected var _containerA:Container;
      
      protected var _containerB:Container;
      
      protected var _containerC:Container;
      
      public function WorldBossDataAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._completion = FuiComponentSelectorUtil.selectComponent("completion",this) as Label;
         this._bg = FuiComponentSelectorUtil.selectComponent("bg",this) as Coreponent;
         this._itemAIcon = FuiComponentSelectorUtil.selectComponent("rewardItems.centerA.icon",this) as Button;
         this._itemAAmount = FuiComponentSelectorUtil.selectComponent("rewardItems.centerA.amount",this) as Label;
         this._itemBIcon = FuiComponentSelectorUtil.selectComponent("rewardItems.centerB.icon",this) as Button;
         this._itemBAmount = FuiComponentSelectorUtil.selectComponent("rewardItems.centerB.amount",this) as Label;
         this._itemCIcon = FuiComponentSelectorUtil.selectComponent("rewardItems.centerC.icon",this) as Button;
         this._itemCAmount = FuiComponentSelectorUtil.selectComponent("rewardItems.centerC.amount",this) as Label;
         this._containerA = FuiComponentSelectorUtil.selectComponent("rewardItems.centerA",this) as Container;
         this._containerB = FuiComponentSelectorUtil.selectComponent("rewardItems.centerB",this) as Container;
         this._containerC = FuiComponentSelectorUtil.selectComponent("rewardItems.centerC",this) as Container;
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:WorldBossListedVO = null;
         _loc2_ = param1 as WorldBossListedVO;
         if(!_loc2_)
         {
            visible = false;
            return;
         }
         this._containerA.visible = this._containerB.visible = this._containerC.visible = false;
         super.data = _loc2_;
         this.prepareItemContainer(_loc2_.itemVoA,this._containerA);
         this.prepareItemContainer(_loc2_.itemVoB,this._containerB);
         this.prepareItemContainer(_loc2_.itemVoC,this._containerC);
      }
      
      protected function prepareItemContainer(param1:ItemVO, param2:Container) : void
      {
         var item:ItemVO = param1;
         var container:Container = param2;
         if(item == null)
         {
            container.visible = false;
            return;
         }
         loadResource(item.getLoot100x100(),function(param1:ImageFinisher):void
         {
            addIconToBtn(param1,container,item);
         },function():void
         {
            addIconToBtn(null,container,item);
         },AssetsProxy.ITEMS);
      }
      
      protected function addIconToBtn(param1:ImageFinisher, param2:Container, param3:ItemVO) : void
      {
         var _loc4_:Button = null;
         var _loc6_:Bitmap = null;
         _loc4_ = param2.getChildByNameRecursively("icon") as Button;
         var _loc5_:Label = param2.getChildByNameRecursively("amount") as Label;
         _loc5_.text = param3.amount.toString();
         _loc4_.tooltipData = param3.fullname + " x" + param3.amount;
         param2.visible = true;
         MovieClipUtils.cleanupDisplayObjectContainer(_loc4_);
         if(param1 != null)
         {
            _loc6_ = new Bitmap(param1.getBitmap().bitmapData);
            _loc6_.width = _loc4_.width;
            _loc6_.height = _loc4_.height;
            _loc4_.addChild(_loc6_);
         }
         else
         {
            param2.visible = false;
         }
      }
   }
}

