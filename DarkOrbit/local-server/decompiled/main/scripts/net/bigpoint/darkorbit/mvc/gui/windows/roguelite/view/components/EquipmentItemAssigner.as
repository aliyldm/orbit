package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.components
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.ui.items.StarLevelDisplayHelper;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class EquipmentItemAssigner extends DefaultItemDataAssigner
   {
      
      protected var _img:Coreponent;
      
      protected var _upgradeLevel:Label;
      
      private var _starLayer:Sprite;
      
      public function EquipmentItemAssigner()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         this.update(param1 as ItemVO);
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._img = FuiComponentSelectorUtil.selectComponent("pic",this) as Coreponent;
         this._upgradeLevel = FuiComponentSelectorUtil.selectComponent("itemUpgradeLevel",this) as Label;
         this._starLayer = new Sprite();
         this._starLayer.name = "starLayer";
         this._starLayer.mouseEnabled = false;
         this._starLayer.mouseChildren = false;
         this._starLayer.x = this._img.x;
         this._starLayer.y = this._img.y;
         this._starLayer.graphics.beginFill(0,0);
         this._starLayer.graphics.drawRect(0,0,this._img.width,this._img.height);
         this._starLayer.graphics.endFill();
         addChild(this._starLayer);
      }
      
      protected function update(param1:ItemVO) : void
      {
         if(param1 == null)
         {
            StarLevelDisplayHelper.render(this._starLayer,null);
            return;
         }
         StarLevelDisplayHelper.render(this._starLayer,param1);
         this._img.removeAllCoreponents();
         loadResource(param1.getLoot30x30(Hero.factionName),this.handleLoadComplete,this.handleLoadFail,AssetsProxy.ITEMS);
         if(param1.upgradeLevel > 0)
         {
            this._upgradeLevel.text = (param1.upgradeLevel + 1).toString();
            this._upgradeLevel.visible = true;
         }
         else
         {
            this._upgradeLevel.visible = false;
         }
         tooltipData = param1.fullname;
      }
      
      protected function handleLoadFail(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
      }
      
      protected function handleLoadComplete(param1:ImageFinisher) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
         this._img.addChild(new Bitmap(param1.getBitmap().bitmapData));
      }
   }
}

