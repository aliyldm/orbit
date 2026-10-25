package net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials
{
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.com.module.porting.trinitytrials.TrinityTrialsGateEnterRequest;
   import net.bigpoint.darkorbit.com.module.porting.trinitytrials.TrinityTrialsGateWindowCommand;
   import net.bigpoint.darkorbit.delete_in_eic.IconVOLoader;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.list.dropdownbox.DropDownBoxEvent;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.model.TrinityTrialsConst;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.model.TrinityTrialsMainProxy;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   
   public class TrinityTrialsSelectViewMediator extends SimpleWindowMediator
   {
      
      private var _view:TrinityTrialsSelectView;
      
      private var _mapBitmap:Bitmap;
      
      private var _proxy:TrinityTrialsMainProxy;
      
      public function TrinityTrialsSelectViewMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         window.addEventListener(SimpleWindowEvent.ON_MAXIMIZED,this.onShowHandler);
         window.addEventListener(SimpleWindowEvent.ON_MINIMIZE,this.onCloseHandler);
         this._proxy = TrinityTrialsMainProxy.getProxy();
         this._proxy.viewData.dataChange.add(this.dataChangeHandler);
      }
      
      override public function onRemove() : void
      {
         this._proxy.viewData.dataChange.remove(this.dataChangeHandler);
      }
      
      private function dataChangeHandler(param1:String) : void
      {
         if(param1 == TrinityTrialsConst.DIFFICULTY_SELECT)
         {
            this.updateView();
         }
      }
      
      private function onShowHandler(param1:SimpleWindowEvent) : void
      {
      }
      
      private function onCloseHandler(param1:SimpleWindowEvent) : void
      {
         this._view && this._view.gateSelection && this._view.gateSelection.forceCollapse();
         this._view && this._view.difficultySelection && this._view.difficultySelection.forceCollapse();
      }
      
      private function updateView() : void
      {
         var command:TrinityTrialsGateWindowCommand = null;
         var mapList:Vector.<String> = null;
         var mapName:String = null;
         var i:int = 0;
         var diffList:Vector.<String> = null;
         var costItemVO:ItemVO = null;
         if(_uiReady)
         {
            command = this._proxy.viewData.gateCommand;
            mapList = new Vector.<String>();
            mapName = "";
            i = 0;
            while(i < command.openAttributes.length)
            {
               mapList.push("trinitytrials_gate_map_" + command.openAttributes[i].param0);
               if(mapName != "")
               {
                  mapName += ",";
               }
               mapName += "<font color=\'#e4b549\'>" + BPLocale.getItem("trinitytrials_gate_map_" + command.openAttributes[i].param0) + "</font>";
               i++;
            }
            this._view.gateSelection.updateAvailableEntries(mapList);
            this._view.infoLabel.useHTML = true;
            this._view.infoLabel.text = BPLocale.getItem("trinitytrials_gate_open").replace("%VALUE%",mapName);
            diffList = new Vector.<String>();
            i = 0;
            while(i < 5)
            {
               diffList.push("trinitytrials_difficulty" + (i + 1));
               i++;
            }
            this._view.difficultySelection.updateAvailableEntries(diffList);
            this._view.difficultySelection.currentEntry = command.openDifficulty - 1;
            costItemVO = ItemDataProviderHelper.getItem("" + this._proxy.viewData.gateCommand.lootId);
            if(costItemVO)
            {
               IconVOLoader.getInstance().loadIcon(this._view.itemIcon,costItemVO,"100x100",AssetsProxy.ITEMS);
               this._view.itemIcon.tooltipData = "" + costItemVO.fullname;
            }
            this._view.itemNumLabel.useHTML = true;
            if(this._proxy.viewData.gateCommand.curLootAmount > 0)
            {
               this._view.itemNumLabel.text = "x1";
            }
            else
            {
               this._view.itemNumLabel.text = "<font color=\'#FF0000\'>x1</font>";
            }
         }
         setTimeout(function():void
         {
            simpleWindow.getUIContainer().visible = true;
         },1);
      }
      
      private function onGateSelectHandler(param1:DropDownBoxEvent) : void
      {
         var _loc2_:TrinityTrialsGateWindowCommand = this._proxy.viewData.gateCommand;
         var _loc3_:String = "tt_map" + _loc2_.openAttributes[this._view.gateSelection.currentEntry].param0;
         ResourceManager.fileCollection.load(_loc3_,this.handleFileLoadComplete);
         this._view.costContainer.visible = _loc2_.openAttributes[this._view.gateSelection.currentEntry].param1 == "0";
      }
      
      private function onDifficultySelectHandler(param1:DropDownBoxEvent) : void
      {
         var _loc2_:TrinityTrialsGateWindowCommand = this._proxy.viewData.gateCommand;
         this._view.goBtn.enabled = this._view.difficultySelection.currentEntry < _loc2_.openDifficulty;
      }
      
      private function initViewComponent() : void
      {
         this._view = new TrinityTrialsSelectView(simpleWindow);
         this._view.gateSelection.addEventListener(DropDownBoxEvent.SELECTED_ENTRY_CHANGED,this.onGateSelectHandler);
         this._view.difficultySelection.addEventListener(DropDownBoxEvent.SELECTED_ENTRY_CHANGED,this.onDifficultySelectHandler);
         this._view.goBtn.addEventListener(MouseEvent.CLICK,this.onClickHandler);
         this._view.goBtn.buttonMode = true;
         simpleWindow.removeInprogressOverLay();
         _uiReady = true;
      }
      
      private function handleFileLoadComplete(param1:ImageFinisher) : void
      {
         if(Boolean(this._mapBitmap) && Boolean(this._mapBitmap.bitmapData))
         {
            this._mapBitmap.bitmapData.dispose();
            this._mapBitmap.parent.removeChild(this._mapBitmap);
            this._mapBitmap = null;
         }
         this._mapBitmap = new Bitmap();
         this._mapBitmap.bitmapData = param1.getBitmap().bitmapData.clone();
         this._view.mapIcon.addChild(this._mapBitmap);
         this._mapBitmap.smoothing = true;
         param1.dispose();
      }
      
      private function onClickHandler(param1:MouseEvent) : void
      {
         if(this._proxy.viewData.gateCommand.curLootAmount > 0 || this._proxy.viewData.gateCommand.openAttributes[this._view.gateSelection.currentEntry].param1 == "1")
         {
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new TrinityTrialsGateEnterRequest(int(this._proxy.viewData.gateCommand.openAttributes[this._view.gateSelection.currentEntry].param0),this._view.difficultySelection.currentEntry + 1));
            guiManager.getWindow(TrinityTrialsConst.DIFFICULTY_SELECT).minimize();
         }
         else
         {
            this.goHtmlShop();
         }
      }
      
      protected function goHtmlShop() : void
      {
         JavascriptProxy.referToURL("internalDock&tpl=internalDockSpecials&shopItem=package_event-deal-trinity-token",null);
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         simpleWindow.getUIContainer().visible = false;
         this.initViewComponent();
         this.updateView();
      }
   }
}

