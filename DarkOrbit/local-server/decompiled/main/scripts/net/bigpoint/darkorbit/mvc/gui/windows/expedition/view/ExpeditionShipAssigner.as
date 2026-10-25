package net.bigpoint.darkorbit.mvc.gui.windows.expedition.view
{
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionShipCommand;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.items.item.vo.Slot;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.ExpeditionNotification;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.mediator.ExpeditionShipHangarMediator;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class ExpeditionShipAssigner extends DefaultItemDataAssigner
   {
      
      private var _nameLabel:Label;
      
      private var _bg:Coreponent;
      
      private var _shipIcon:Coreponent;
      
      private var _selectBG:Coreponent;
      
      private var _oldData:Object;
      
      private var progressBar1:ProgressBar;
      
      private var progressBar2:ProgressBar;
      
      private var progressBar3:ProgressBar;
      
      private var _infoLabel1:Label;
      
      private var _infoLabel2:Label;
      
      private var _infoLabel3:Label;
      
      private var _infoLabel4:Label;
      
      public function ExpeditionShipAssigner()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:ExpeditionShipCommand = null;
         var _loc3_:ExpeditionShipHangarMediator = null;
         var _loc4_:ItemVO = null;
         var _loc5_:Slot = null;
         var _loc6_:Slot = null;
         var _loc7_:int = 0;
         var _loc8_:Slot = null;
         var _loc9_:Slot = null;
         var _loc10_:Slot = null;
         var _loc11_:ItemVO = null;
         super.data = param1;
         if(param1 != null)
         {
            _loc2_ = param1 as ExpeditionShipCommand;
            if(_loc2_)
            {
               _loc3_ = GameFacade.getInstance().retrieveMediator(ExpeditionShipHangarMediator.NAME) as ExpeditionShipHangarMediator;
               if(_loc3_.selectedShip.indexOf(_loc2_.hangarId) != -1)
               {
                  this._selectBG.visible = true;
               }
               else
               {
                  this._selectBG.visible = false;
               }
               if(this._oldData != param1)
               {
                  MovieClipUtils.cleanupDisplayObjectContainer(this._shipIcon);
                  _loc11_ = ItemDataProviderHelper.getItem(_loc2_.lootId);
                  loadResource(_loc11_.getLoot100x100(Hero.factionName),this.handleItemIconLoaded,this.handleItemIconLoadError,AssetsProxy.ITEMS);
               }
               this.progressBar1.update(_loc2_.hp,_loc2_.maxHp);
               this.progressBar2.update(_loc2_.shield,_loc2_.maxShield);
               this.progressBar3.update(_loc2_.nano,_loc2_.maxNano);
               _loc4_ = ItemDataProviderHelper.getItem(_loc2_.lootId);
               _loc5_ = _loc4_.getSlotByName("lasers");
               _loc6_ = _loc4_.getSlotByName("heavy_guns");
               _loc7_ = _loc5_.size + _loc6_.size;
               _loc8_ = _loc4_.getSlotByName("generators");
               _loc9_ = _loc4_.getSlotByName("extras");
               _loc10_ = _loc4_.getSlotByName("ship_upgrades");
               this._infoLabel1.text = "" + BPLocale.getItem("window_dse_ship_choose_laser") + "" + (_loc2_.lasers + _loc2_.rockets) + "/" + _loc7_;
               this._infoLabel2.text = "" + BPLocale.getItem("window_dse_ship_choose_generator") + "" + _loc2_.generators + "/" + _loc8_.size;
               this._infoLabel3.text = "" + BPLocale.getItem("window_dse_ship_choose_extra") + "" + _loc2_.extras + "/" + _loc9_.size;
               this._infoLabel4.text = "" + BPLocale.getItem("window_dse_ship_choose_rocket") + "" + _loc2_.modules + "/" + _loc10_.size;
            }
         }
         this._oldData = param1;
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
         this.addEventListener(MouseEvent.CLICK,this.onMouseClickHandler);
         this._infoLabel1 = FuiComponentSelectorUtil.selectComponent("ship_info_label_1",this) as Label;
         this._infoLabel2 = FuiComponentSelectorUtil.selectComponent("ship_info_label_2",this) as Label;
         this._infoLabel3 = FuiComponentSelectorUtil.selectComponent("ship_info_label_3",this) as Label;
         this._infoLabel4 = FuiComponentSelectorUtil.selectComponent("ship_info_label_4",this) as Label;
         this.progressBar1 = new ProgressBar(125,8,63496);
         this.progressBar1.x = 3;
         this.progressBar1.y = 110;
         this.addChild(this.progressBar1);
         this.progressBar2 = new ProgressBar(125,8,16309504);
         this.progressBar2.x = 3;
         this.progressBar2.y = 120;
         this.addChild(this.progressBar2);
         this.progressBar3 = new ProgressBar(125,8,20984);
         this.progressBar3.x = 3;
         this.progressBar3.y = 130;
         this.addChild(this.progressBar3);
      }
      
      private function onMouseClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:ExpeditionShipHangarMediator = GameFacade.getInstance().retrieveMediator(ExpeditionShipHangarMediator.NAME) as ExpeditionShipHangarMediator;
         var _loc3_:ExpeditionShipCommand = data as ExpeditionShipCommand;
         var _loc4_:int = _loc2_.selectedShip.indexOf(_loc3_.hangarId);
         if(_loc4_ != -1)
         {
            _loc2_.selectedShip.splice(_loc4_,1);
            this._selectBG.visible = false;
         }
         else if(_loc2_.selectedShip.length < 5)
         {
            this._selectBG.visible = true;
            _loc2_.selectedShip.push(_loc3_.hangarId);
         }
         GameFacade.getInstance().sendNotification(ExpeditionNotification.SHIP_SELECTED_UPDATE);
      }
      
      override protected function drawSelection() : void
      {
         super.drawSelection();
      }
   }
}

