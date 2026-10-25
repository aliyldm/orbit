package net.bigpoint.darkorbit.mvc.gui.windows.expedition.view
{
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionShipCommand;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.ExpeditionNotification;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.mediator.ExpeditionShipWarpMediator;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class ExpeditionShipWarpAssigner extends DefaultItemDataAssigner
   {
      
      private var _nameLabel:Label;
      
      private var _bg:Coreponent;
      
      private var _shipIcon:Coreponent;
      
      private var _selectBG:Coreponent;
      
      private var _darkLayer:Coreponent;
      
      private var _destroyedLabel:Label;
      
      private var progressBar1:ProgressBar;
      
      private var progressBar2:ProgressBar;
      
      private var progressBar3:ProgressBar;
      
      public function ExpeditionShipWarpAssigner()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc3_:ExpeditionShipWarpMediator = null;
         var _loc4_:ItemVO = null;
         super.data = param1;
         var _loc2_:ExpeditionShipCommand = param1 as ExpeditionShipCommand;
         if(_loc2_)
         {
            _loc3_ = GameFacade.getInstance().retrieveMediator(GuiConstants.EXPEDITION_SHIPWARP) as ExpeditionShipWarpMediator;
            this._selectBG.visible = _loc3_.selectShip == _loc2_.hangarId;
            MovieClipUtils.cleanupDisplayObjectContainer(this._shipIcon);
            _loc4_ = ItemDataProviderHelper.getItem(_loc2_.lootId);
            loadResource(_loc4_.getLoot100x100(Hero.factionName),this.handleItemIconLoaded,this.handleItemIconLoadError,AssetsProxy.ITEMS);
            this._nameLabel.text = _loc4_.fullname;
            if(_loc2_.destroyed)
            {
               this.progressBar1.update(0,_loc2_.maxHp);
               this.progressBar2.update(0,_loc2_.maxShield);
               this.progressBar3.update(0,_loc2_.maxNano);
               this._destroyedLabel.visible = true;
               this._darkLayer.visible = true;
            }
            else
            {
               this.progressBar1.update(_loc2_.hp,_loc2_.maxHp);
               this.progressBar2.update(_loc2_.shield,_loc2_.maxShield);
               this.progressBar3.update(_loc2_.nano,_loc2_.maxNano);
               this._destroyedLabel.visible = false;
               this._darkLayer.visible = false;
            }
         }
      }
      
      private function handleItemIconLoaded(param1:ImageFinisher = null) : void
      {
         var _loc2_:Bitmap = null;
         MovieClipUtils.cleanupDisplayObjectContainer(this._shipIcon);
         _loc2_ = new Bitmap(param1.getBitmap().bitmapData);
         _loc2_.x = (this._shipIcon.width - _loc2_.width) / 2;
         _loc2_.y = (this._shipIcon.height - _loc2_.height) / 2;
         this._shipIcon.addChild(_loc2_);
      }
      
      private function handleItemIconLoadError(param1:*) : void
      {
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._bg = FuiComponentSelectorUtil.selectComponent("ship_bg",this) as Coreponent;
         this._shipIcon = FuiComponentSelectorUtil.selectComponent("ship_icon",this) as Coreponent;
         this._nameLabel = FuiComponentSelectorUtil.selectComponent("ship_name_label",this) as Label;
         this._selectBG = FuiComponentSelectorUtil.selectComponent("ship_select_bg",this) as Coreponent;
         this._destroyedLabel = FuiComponentSelectorUtil.selectComponent("ship_destroyed_label",this) as Label;
         this._darkLayer = FuiComponentSelectorUtil.selectComponent("darkLayer",this) as Coreponent;
         this.progressBar1 = new ProgressBar(125,8,63496);
         this.progressBar1.x = 3;
         this.progressBar1.y = 150;
         this.addChild(this.progressBar1);
         this.progressBar2 = new ProgressBar(125,8,16309504);
         this.progressBar2.x = 3;
         this.progressBar2.y = 160;
         this.addChild(this.progressBar2);
         this.progressBar3 = new ProgressBar(125,8,20984);
         this.progressBar3.x = 3;
         this.progressBar3.y = 170;
         this.addChild(this.progressBar3);
         this.addEventListener(MouseEvent.CLICK,this.onMouseClickHandler);
         this._destroyedLabel.rotation = -30;
      }
      
      private function onMouseClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:ExpeditionShipWarpMediator = null;
         _loc2_ = GameFacade.getInstance().retrieveMediator(GuiConstants.EXPEDITION_SHIPWARP) as ExpeditionShipWarpMediator;
         var _loc3_:ExpeditionShipCommand = data as ExpeditionShipCommand;
         if(!_loc3_.destroyed)
         {
            this._selectBG.visible = true;
            _loc2_.selectShip = _loc3_.hangarId;
         }
         else
         {
            GameFacade.getInstance().sendNotification(ExpeditionNotification.SHIP_WARP_SELECT);
         }
      }
      
      override protected function drawSelection() : void
      {
         super.drawSelection();
         this._selectBG.visible = this.isSelected();
      }
   }
}

