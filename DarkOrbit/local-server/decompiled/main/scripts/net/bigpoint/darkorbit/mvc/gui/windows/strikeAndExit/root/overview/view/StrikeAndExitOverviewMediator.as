package net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.overview.view
{
   import com.bigpoint.utils.TimeFormatter;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.porting.strikeandexit.StrikeAndExitInfoRequest;
   import net.bigpoint.darkorbit.delete_in_eic.IconVOLoader;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.overview.model.StrikeAndExitOverviewData;
   import net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.shop.ViewData;
   
   public class StrikeAndExitOverviewMediator extends SimpleWindowMediator implements ViewData
   {
      
      private var _view:StrikeAndExitOverviewView;
      
      private var _viewData:StrikeAndExitOverviewData;
      
      protected const lootId:String = "resource_collectable_stellar-coin";
      
      private var coinItemVO:ItemVO;
      
      private var openTime:Label;
      
      private var coinMinLeft:Label;
      
      private var icon:Coreponent;
      
      private var inDouble:Coreponent;
      
      private var inDouble_bg1:Coreponent;
      
      private var inDoubleIcon:Coreponent;
      
      private var infoButton:Button;
      
      private var banner:Coreponent;
      
      public const _markKey:String = "mark";
      
      private var sCom:StrikeAndExitInfoRequest = new StrikeAndExitInfoRequest();
      
      public function StrikeAndExitOverviewMediator(param1:String, param2:SimpleWindow, param3:StrikeAndExitOverviewData)
      {
         super(param1,param2);
         this._viewData = param3;
         this._viewData.changed.add(this.updateView);
      }
      
      public function refreshData() : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,this.sCom);
      }
      
      private function onAttemptsUpdated() : void
      {
         if(Boolean(this._view) && this._view.visible)
         {
            if(this._viewData.attemptsLeft.value > 0)
            {
               this.openTime.text = BPLocale.getItem("strikeandexit_overview_gate_close").replace("%TIME%",TimeFormatter.getSmartFormatedTime(this._viewData.attemptsLeft.value));
            }
            else
            {
               this.openTime.text = BPLocale.getItem("strikeandexit_overview_gate_run");
            }
         }
         else
         {
            this._viewData.attemptsLeft.changed.remove(this.onAttemptsUpdated);
            this.openTime.text = "";
         }
      }
      
      private function updateView() : void
      {
         if(this._view)
         {
            this.coinMinLeft.text = (this.coinItemVO ? this.coinItemVO.fullname : "") + " " + this._viewData.currentGetStellarCoin + "/" + this._viewData.stellarCoinLimit;
            this.inDouble.visible = this._viewData.inDouble;
            if(this._viewData.inSession)
            {
               this.openTime.text = BPLocale.getItem("strikeandexit_overview_gate_run");
            }
            else
            {
               this._viewData.attemptsLeft.changed.add(this.onAttemptsUpdated);
            }
         }
      }
      
      public function setView(param1:StrikeAndExitOverviewView) : void
      {
         this._view = param1;
         this.openTime = this._view.openTime;
         this.icon = this._view.icon;
         this.coinMinLeft = this._view.coinMinLeft;
         this.inDouble_bg1 = this._view.inDoubleBg1;
         this.inDouble = this._view.inDouble;
         this.inDoubleIcon = this._view.inDoubleIcon;
         this.infoButton = this._view.infoBtn;
         this.infoButton.tooltipData = BPLocale.getItem("strikeandexit_overview_sco_cap_info");
         this.banner = this._view.banner;
         this.setBannerIcon();
      }
      
      private function setBannerIcon() : void
      {
         if(!this.coinItemVO)
         {
            this.coinItemVO = ItemDataProviderHelper.getItem(this.lootId);
         }
         IconVOLoader.getInstance().loadIcon(this.icon,this.coinItemVO,"100x100");
         IconVOLoader.getInstance().loadIcon(this.inDoubleIcon,this.coinItemVO,"100x100");
         IconVOLoader.getInstance().loadIcon(this.inDouble_bg1,null,this._markKey,AssetsProxy.EVENTS);
         IconVOLoader.getInstance().loadIcon(this.banner,null,"background25",AssetsProxy.EVENTS);
         (this.inDouble_bg1 as Sprite).rotation = -15;
      }
   }
}

