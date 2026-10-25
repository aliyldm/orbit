package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.components
{
   import flash.display.Bitmap;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model.vo.RogueLiteDroneVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.ui.items.StarLevelDisplayHelper;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class DroneItemAssigner extends DefaultItemDataAssigner
   {
      
      protected var _img1outline:Coreponent;
      
      protected var _img1:Coreponent;
      
      protected var _img2:Coreponent;
      
      protected var _equip1Level:Label;
      
      protected var _equip2Level:Label;
      
      protected var _name:Label;
      
      protected var _level:Label;
      
      protected var _effect:Label;
      
      protected var _rightDivider:Coreponent;
      
      private var _starLayer1:Sprite;
      
      private var _starLayer2:Sprite;
      
      public function DroneItemAssigner()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         this.update(param1 as RogueLiteDroneVO);
      }
      
      override public function set index(param1:int) : void
      {
         super.index = param1;
         this._rightDivider.visible = param1 % 2 == 0;
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._name = FuiComponentSelectorUtil.selectComponent("name",this) as Label;
         this._level = FuiComponentSelectorUtil.selectComponent("level",this) as Label;
         this._effect = FuiComponentSelectorUtil.selectComponent("effect",this) as Label;
         this._img1 = FuiComponentSelectorUtil.selectComponent("equip1outline.equip1",this) as Coreponent;
         this._img2 = FuiComponentSelectorUtil.selectComponent("equip2outline.equip2",this) as Coreponent;
         this._equip1Level = FuiComponentSelectorUtil.selectComponent("equip1outline.itemLevel",this) as Label;
         this._equip2Level = FuiComponentSelectorUtil.selectComponent("equip2outline.itemLevel",this) as Label;
         this._img1outline = FuiComponentSelectorUtil.selectComponent("equip1outline",this) as Coreponent;
         this._rightDivider = FuiComponentSelectorUtil.selectComponent("right_divider",this) as Coreponent;
         this._starLayer1 = this.createStarLayer(this._img1);
         this._starLayer2 = this.createStarLayer(this._img2);
      }
      
      protected function update(param1:RogueLiteDroneVO) : void
      {
         StarLevelDisplayHelper.render(this._starLayer1,null);
         StarLevelDisplayHelper.render(this._starLayer2,null);
         if(param1 == null)
         {
            return;
         }
         this._img1.removeAllCoreponents();
         this._img2.removeAllCoreponents();
         this._name.text = param1.droneName;
         this._level.text = param1.droneLevel.toString();
         this._effect.text = param1.droneEffect;
         switch(param1.droneSlot)
         {
            case 1:
               if(param1.equip1)
               {
                  this.displayDroneEquipment(param1.equip1,this._img2,this._equip2Level);
               }
               this._img1outline.visible = false;
               break;
            case 2:
               if(param1.equip1)
               {
                  this.displayDroneEquipment(param1.equip1,this._img1,this._equip1Level);
               }
               if(param1.equip2)
               {
                  this.displayDroneEquipment(param1.equip2,this._img2,this._equip2Level);
               }
               this._img1outline.visible = true;
         }
      }
      
      private function displayDroneEquipment(param1:ItemVO, param2:Coreponent, param3:Label) : void
      {
         StarLevelDisplayHelper.render(param2 == this._img1 ? this._starLayer1 : this._starLayer2,param1);
         loadResource(param1.getLoot30x30(),this.handleLoadComplete(param2),this.handleLoadFail(param2),AssetsProxy.ITEMS);
         param2.tooltipData = param1.fullname;
         if(param1.upgradeLevel > 0)
         {
            param3.text = (param1.upgradeLevel + 1).toString();
            param3.visible = true;
         }
         else
         {
            param3.visible = false;
         }
      }
      
      private function createStarLayer(param1:Coreponent) : Sprite
      {
         var _loc2_:Sprite = null;
         _loc2_ = new Sprite();
         _loc2_.name = "starLayer";
         _loc2_.mouseEnabled = false;
         _loc2_.mouseChildren = false;
         _loc2_.x = param1.x;
         _loc2_.y = param1.y;
         _loc2_.graphics.beginFill(0,0);
         _loc2_.graphics.drawRect(0,0,param1.width,param1.height);
         _loc2_.graphics.endFill();
         param1.parent.addChild(_loc2_);
         return _loc2_;
      }
      
      protected function handleLoadFail(param1:Coreponent) : Function
      {
         var img:Coreponent = param1;
         return function(param1:*):void
         {
            MovieClipUtils.cleanupDisplayObjectContainer(img);
         };
      }
      
      protected function handleLoadComplete(param1:Coreponent) : Function
      {
         var img:Coreponent = param1;
         return function(param1:ImageFinisher):void
         {
            MovieClipUtils.cleanupDisplayObjectContainer(img);
            var _loc2_:* = new Bitmap(param1.getBitmap().bitmapData);
            img.addChild(_loc2_);
         };
      }
   }
}

