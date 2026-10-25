package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view
{
   import com.bigpoint.utils.TimeFormatter;
   import com.bigpoint.utils.bindables.BindableCountDown;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.GalaxyGateBuilderModel;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo.GateBonusGGRewardVO;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.core.CompositeView;
   
   public class BonusGateRewardView extends CompositeView
   {
      
      private var gateBonusRewardsRect:Rectangle;
      
      private var gateBonusRewardsBackgroundBitmapData:BitmapData;
      
      private var bonusRewardsTitle:TextField;
      
      private var bonusRewardsDescription:TextField;
      
      private var bonusRewardsTimeRemaining:TextField;
      
      private var bonusRewardsItemTitle:TextField;
      
      private var bonusRewardsOverlayText:TextField;
      
      private var bonusRewardItemBitmap:Bitmap;
      
      private var bonusRewardItemIconData:BitmapData;
      
      private var bonusRewardItemIconRect:Rectangle;
      
      private var bonusRewardItemOverlayData:BitmapData;
      
      private var bonusRewardItemOverlay:Bitmap;
      
      private var stubAnchor:Point;
      
      private var commonLib:SWFFinisher;
      
      private var bonusRewardVO:GateBonusGGRewardVO;
      
      private var timerCountdown:BindableCountDown = new BindableCountDown();
      
      public function BonusGateRewardView(param1:Object, param2:Object = null)
      {
         super(param1,param2);
      }
      
      public function init(param1:int = 1, param2:int = 0) : void
      {
         var _loc4_:Bitmap = null;
         var _loc6_:Bitmap = null;
         var _loc9_:TextFormat = null;
         var _loc3_:AssetsProxy = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         this.commonLib = SWFFinisher(_loc3_.getLib("common"));
         this.stubAnchor = new Point(0,0);
         this.gateBonusRewardsRect = new Rectangle(0,0,param2,175);
         this.gateBonusRewardsBackgroundBitmapData = new BitmapData(this.gateBonusRewardsRect.width,this.gateBonusRewardsRect.height,true,3423147044);
         _loc4_ = new Bitmap(this.gateBonusRewardsBackgroundBitmapData);
         _loc4_.x = 10;
         _loc4_.y = 54;
         this.addChild(_loc4_);
         var _loc5_:BitmapData = this.commonLib.getEmbeddedBitmapData("bonusRewardBackgroundFrame");
         _loc6_ = new Bitmap(_loc5_);
         _loc6_.x = 10;
         _loc6_.y = 54;
         this.addChild(_loc6_);
         var _loc7_:BitmapData = this.commonLib.getEmbeddedBitmapData("bonus_gg_reward");
         var _loc8_:Bitmap = new Bitmap(_loc7_);
         _loc8_.x = 20;
         _loc8_.y = 60;
         this.addChild(_loc8_);
         this.bonusRewardsTitle = new TextField();
         _loc9_ = Styles.ggBuilderH3Fmt;
         _loc9_.align = TextFormatAlign.LEFT;
         this.bonusRewardsTitle.defaultTextFormat = _loc9_;
         this.bonusRewardsTitle.embedFonts = Styles.ggBuilderH3Embed;
         this.bonusRewardsTitle.height = Styles.ggBuilderPlainBigFontHeight;
         this.bonusRewardsTitle.width = 220;
         this.bonusRewardsTitle.antiAliasType = AntiAliasType.ADVANCED;
         this.bonusRewardsTitle.textColor = 16763904;
         this.bonusRewardsTitle.selectable = false;
         this.bonusRewardsTitle.text = BPLocale.getItemInCategory("galaxyGates","title_bonus_gg_reward");
         this.bonusRewardsTitle.x = 53;
         this.bonusRewardsTitle.y = 68;
         addChild(this.bonusRewardsTitle);
         this.bonusRewardsDescription = new TextField();
         _loc9_ = Styles.bonusGateDescFmt;
         _loc9_.align = TextFormatAlign.LEFT;
         this.bonusRewardsDescription.defaultTextFormat = _loc9_;
         this.bonusRewardsDescription.embedFonts = Styles.bonusGateDescEmbed;
         this.bonusRewardsDescription.height = 100;
         this.bonusRewardsDescription.width = 170;
         this.bonusRewardsDescription.antiAliasType = AntiAliasType.ADVANCED;
         this.bonusRewardsDescription.textColor = 16777215;
         this.bonusRewardsDescription.selectable = false;
         this.bonusRewardsDescription.text = BPLocale.getItemInCategory("galaxyGates","msg_bonus_gg_reward_info");
         this.bonusRewardsDescription.x = 20;
         this.bonusRewardsDescription.y = 90;
         this.bonusRewardsDescription.wordWrap = true;
         addChild(this.bonusRewardsDescription);
         this.bonusRewardsTimeRemaining = new TextField();
         _loc9_ = Styles.bonusGateDescFmt;
         _loc9_.align = TextFormatAlign.LEFT;
         this.bonusRewardsTimeRemaining.defaultTextFormat = _loc9_;
         this.bonusRewardsTimeRemaining.embedFonts = Styles.bonusGateDescEmbed;
         this.bonusRewardsTimeRemaining.height = 30;
         this.bonusRewardsTimeRemaining.width = 500;
         this.bonusRewardsTimeRemaining.antiAliasType = AntiAliasType.ADVANCED;
         this.bonusRewardsTimeRemaining.textColor = 16763904;
         this.bonusRewardsTimeRemaining.selectable = false;
         this.bonusRewardsTimeRemaining.text = BPLocale.getItemInCategory("galaxyGates","msg_bonus_gg_reward_time_left");
         this.bonusRewardsTimeRemaining.x = 20;
         this.bonusRewardsTimeRemaining.y = 197;
         addChild(this.bonusRewardsTimeRemaining);
         this.timerCountdown.changed.add(this.handleCountdown);
         var _loc10_:BitmapData = this.commonLib.getEmbeddedBitmapData("bonusRewardItemFrame");
         var _loc11_:Bitmap = new Bitmap(_loc10_);
         _loc11_.x = 200;
         _loc11_.y = 55;
         this.addChild(_loc11_);
         this.bonusRewardItemIconRect = new Rectangle(0,0,100,100);
         this.bonusRewardItemIconData = new BitmapData(this.bonusRewardItemIconRect.width,this.bonusRewardItemIconRect.height,true,4294967295);
         this.bonusRewardItemBitmap = new Bitmap(this.bonusRewardItemIconData);
         this.bonusRewardItemBitmap.x = 215;
         this.bonusRewardItemBitmap.y = 105;
         addChild(this.bonusRewardItemBitmap);
         this.bonusRewardsItemTitle = new TextField();
         _loc9_ = Styles.bonusGateDescFmt;
         _loc9_.align = TextFormatAlign.CENTER;
         this.bonusRewardsItemTitle.defaultTextFormat = _loc9_;
         this.bonusRewardsItemTitle.embedFonts = Styles.bonusGateDescEmbed;
         this.bonusRewardsItemTitle.height = 100;
         this.bonusRewardsItemTitle.width = 120;
         this.bonusRewardsItemTitle.antiAliasType = AntiAliasType.ADVANCED;
         this.bonusRewardsItemTitle.textColor = 16777215;
         this.bonusRewardsItemTitle.selectable = false;
         this.bonusRewardsItemTitle.text = "";
         this.bonusRewardsItemTitle.x = 207;
         this.bonusRewardsItemTitle.y = 75;
         this.bonusRewardsItemTitle.wordWrap = true;
         addChild(this.bonusRewardsItemTitle);
         this.bonusRewardItemOverlayData = new BitmapData(120,145,true,2566914048);
         this.bonusRewardItemOverlay = new Bitmap(this.bonusRewardItemOverlayData);
         this.bonusRewardItemOverlay.x = 205;
         this.bonusRewardItemOverlay.y = 67;
         addChild(this.bonusRewardItemOverlay);
         this.bonusRewardsOverlayText = new TextField();
         _loc9_ = Styles.bonusGateDescFmt;
         _loc9_.align = TextFormatAlign.CENTER;
         this.bonusRewardsOverlayText.defaultTextFormat = _loc9_;
         this.bonusRewardsOverlayText.embedFonts = Styles.bonusGateDescEmbed;
         this.bonusRewardsOverlayText.height = 100;
         this.bonusRewardsOverlayText.width = 120;
         this.bonusRewardsOverlayText.antiAliasType = AntiAliasType.ADVANCED;
         this.bonusRewardsOverlayText.textColor = 16777215;
         this.bonusRewardsOverlayText.selectable = false;
         this.bonusRewardsOverlayText.text = BPLocale.getItemInCategory("galaxyGates","msg_bonus_gg_reward_collected");
         this.bonusRewardsOverlayText.x = 207;
         this.bonusRewardsOverlayText.y = 150;
         this.bonusRewardsOverlayText.wordWrap = true;
         addChild(this.bonusRewardsOverlayText);
         this.setGate(param1);
      }
      
      private function handleCountdown() : void
      {
         this.bonusRewardsTimeRemaining.text = BPLocale.getItemInCategory("galaxyGates","msg_bonus_gg_reward_time_left") + TimeFormatter.formatTime(this.timerCountdown.value);
      }
      
      public function setGate(param1:int) : void
      {
         var _loc3_:BitmapData = null;
         var _loc4_:String = null;
         var _loc2_:GalaxyGateBuilderModel = this.model as GalaxyGateBuilderModel;
         this.bonusRewardVO = _loc2_.getGateBonusReward(param1);
         if(this.bonusRewardVO == null)
         {
            visible = false;
         }
         else
         {
            visible = true;
            _loc3_ = _loc2_.getItemImage(param1).bitmapData;
            if(_loc3_ != null)
            {
               this.bonusRewardItemIconData.copyPixels(_loc3_,this.bonusRewardItemIconRect,this.stubAnchor);
            }
            else
            {
               this.bonusRewardItemIconData.fillRect(this.bonusRewardItemIconData.rect,0);
            }
            _loc4_ = _loc2_.getLootText(this.bonusRewardVO.lootId);
            this.bonusRewardsItemTitle.text = this.bonusRewardVO.amount + " " + _loc4_;
            if(this.bonusRewardVO.claimed)
            {
               this.bonusRewardsOverlayText.visible = true;
               this.bonusRewardItemOverlay.visible = true;
            }
            else
            {
               this.bonusRewardsOverlayText.visible = false;
               this.bonusRewardItemOverlay.visible = false;
            }
            this.timerCountdown.value = this.bonusRewardVO.countdown;
         }
      }
   }
}

