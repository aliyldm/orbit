package net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.mediator
{
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.porting.voyagers.VoyagersGateEnterRequest;
   import net.bigpoint.darkorbit.com.module.porting.voyagers.VoyagersGateWindowCommand;
   import net.bigpoint.darkorbit.delete_in_eic.IconVOLoader;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.dropdownbox.DropDownBoxEvent;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.model.SingularityDrivePassProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.model.SingularityDriveSelectDescItemData;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.view.SingularityDriveSelectView;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.view.assigners.SingularityDriveSelectDescListItemRenderer;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   
   public class SingularDriveSelectViewMediator extends SimpleWindowMediator
   {
      
      private var _view:SingularityDriveSelectView;
      
      private var _proxy:SingularityDrivePassProxy;
      
      private var dataComplete:Boolean = false;
      
      public function SingularDriveSelectViewMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         window.addEventListener(SimpleWindowEvent.ON_MAXIMIZED,this.onShowHandler);
         window.addEventListener(SimpleWindowEvent.ON_MINIMIZE,this.onCloseHandler);
         this._proxy = SingularityDrivePassProxy.getProxy();
         this._proxy.viewData.dataChange.add(this.dataChangeHandler);
      }
      
      override public function onRemove() : void
      {
         this._proxy.viewData.dataChange.remove(this.dataChangeHandler);
      }
      
      private function dataChangeHandler(param1:String) : void
      {
         if(param1 == GuiConstants.SINGULARITYDRIVE_DIFFICULTY_SELECT)
         {
            this.dataComplete = true;
            this.updateView();
         }
      }
      
      private function onShowHandler(param1:SimpleWindowEvent) : void
      {
      }
      
      private function onCloseHandler(param1:SimpleWindowEvent) : void
      {
         this._view && this._view.difficultySelection && this._view.difficultySelection.forceCollapse();
      }
      
      private function updateView() : void
      {
         var command:VoyagersGateWindowCommand = null;
         var diffList:Vector.<String> = null;
         var i:* = undefined;
         var costItemVO:ItemVO = null;
         var tempStr:String = null;
         if(_uiReady && this.dataComplete)
         {
            this.dataComplete = false;
            command = this._proxy.viewData.gateCommand;
            diffList = new Vector.<String>();
            i = 0;
            while(i < command.maxOpenLevel)
            {
               if(i + 1 <= 5)
               {
                  diffList.push("voyagersascentrial_difficulty" + (i + 1));
               }
               i++;
            }
            this._view.difficultySelection.updateAvailableEntries(diffList);
            this._view.difficultySelection.currentEntry = command.maxOpenLevel - 1;
            costItemVO = ItemDataProviderHelper.getItem("" + this._proxy.viewData.gateCommand.lootId);
            if(costItemVO)
            {
               IconVOLoader.getInstance().loadIcon(this._view.itemIcon,costItemVO,"100x100",AssetsProxy.ITEMS);
            }
            if(this._proxy.viewData.gateIsFree)
            {
               this._view.itemNameLabel.text = BPLocale.getItemInCategory("","attribute_free_cpu_jump");
               this._view.itemNumLabel.useHTML = true;
               this._view.itemNumLabel.text = "<font color=\'#00FF00\'>" + (this._proxy.viewData.gateCommand.maxFreeNum - this._proxy.viewData.gateCommand.freeChallengedNum) + "</font>" + "/1";
            }
            else
            {
               if(costItemVO)
               {
                  this._view.itemIcon.tooltipData = "" + costItemVO.fullname;
                  this._view.itemNameLabel.text = "" + costItemVO.fullname;
               }
               this._view.itemNumLabel.useHTML = true;
               tempStr = "";
               if(this._proxy.viewData.gateCommand.curLootAmount > 0)
               {
                  tempStr = "<font color=\'#00FF00\'>" + this._proxy.viewData.gateCommand.curLootAmount + "</font>" + "/1";
                  this._view.itemNumLabel.text = tempStr;
               }
               else
               {
                  tempStr = "<font color=\'#FF0000\'>" + this._proxy.viewData.gateCommand.curLootAmount + "</font>" + "/1";
                  this._view.itemNumLabel.text = tempStr;
               }
            }
            this.setListData();
         }
         setTimeout(function():void
         {
            simpleWindow.getUIContainer().visible = true;
         },1);
      }
      
      private function onDifficultySelectHandler(param1:DropDownBoxEvent) : void
      {
         this._view.goBtn.enabled = this._proxy.viewData.gateIsFree || this._proxy.viewData.gateCommand.curLootAmount >= 1;
         var _loc2_:int = param1.index + 1;
         if(_loc2_ != this._proxy.viewData.curLevel)
         {
            this._proxy.viewData.curLevel = _loc2_;
            this.setListData();
         }
      }
      
      private function initViewComponent() : void
      {
         this._view = new SingularityDriveSelectView(simpleWindow);
         this._view.difficultySelection.addEventListener(DropDownBoxEvent.SELECTED_ENTRY_CHANGED,this.onDifficultySelectHandler);
         this._view.goBtn.addEventListener(MouseEvent.CLICK,this.onClickHandler);
         this._view.goBtn.buttonMode = true;
         simpleWindow.removeInprogressOverLay();
         this._view.desc_list.itemDataAssigner = SingularityDriveSelectDescListItemRenderer;
      }
      
      private function setListData() : void
      {
         var _loc3_:SingularityDriveSelectDescItemData = null;
         var _loc1_:Vector.<SingularityDriveSelectDescItemData> = new Vector.<SingularityDriveSelectDescItemData>();
         var _loc2_:* = 2;
         while(_loc2_ >= 0)
         {
            _loc3_ = new SingularityDriveSelectDescItemData(_loc2_);
            _loc1_.push(_loc3_);
            _loc2_--;
         }
         this._view.desc_list.list = new VectorCollection(_loc1_);
      }
      
      private function onClickHandler(param1:MouseEvent) : void
      {
         if(this._proxy.viewData.gateCommand.curLootAmount >= 1 || this._proxy.viewData.gateIsFree)
         {
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new VoyagersGateEnterRequest(this._proxy.viewData.gateIsFree,this._view.difficultySelection.currentEntry + 1));
            guiManager.getWindow(GuiConstants.SINGULARITYDRIVE_DIFFICULTY_SELECT).minimize();
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
         this.initViewComponent();
         this.updateView();
      }
   }
}

