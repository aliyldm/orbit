package net.bigpoint.darkorbit
{
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class Styles
   {
      
      public static const WHITE:uint = 16777215;
      
      public static const GREEN:uint = 65280;
      
      public static const RED:uint = 16711680;
      
      public static const YELLOW:uint = 16763904;
      
      public static var baseEmbed:Boolean = true;
      
      public static const baseFont:String = "EurostileHeaFl";
      
      public static const corporateFontRegular:String = "EurostileFl";
      
      public static const corporateFontHeavy:String = "EurostileHeaFl";
      
      public static const corporateFontExt:String = "EurostileExtFl";
      
      public static const corporateFontRegularFlex:String = "EurostileT";
      
      public static const corporateFontMediumFlex:String = "EurostileTMed";
      
      public static const corporateFontHeavyFlex:String = "EurostileTHea";
      
      public static const deviceFontTahoma:String = "Tahoma";
      
      public static const deviceFontVerdana:String = "Verdana";
      
      public static const hsgHeadFontHeight:int = 16;
      
      public static const hsgHeadFontColour:uint = 13421568;
      
      public static const hsgHeadFmt:TextFormat = new TextFormat(corporateFontHeavy,hsgHeadFontHeight,hsgHeadFontColour);
      
      public static var hsgHeadEmbed:Boolean = true;
      
      public static const clientSelection:TextFormat = new TextFormat(corporateFontHeavy,22,16383743);
      
      public static const clientSelectionHeadline:TextFormat = new TextFormat(corporateFontHeavy,88,16383743);
      
      public static const clientSelectionButton:TextFormat = new TextFormat(corporateFontHeavy,24,16383743);
      
      public static const clientSelectionButton2D:TextFormat = new TextFormat(corporateFontRegularFlex,12,16383743);
      
      public static const hsgBodyFontHeight:int = 18;
      
      public static const hsgBodyFontColour:uint = 10092543;
      
      public static const hsgBodyFmt:TextFormat = new TextFormat(corporateFontRegular,hsgBodyFontHeight,hsgBodyFontColour);
      
      public static var hsgBodyEmbed:Boolean = true;
      
      public static const systemSplashFontHeight:int = 20;
      
      public static const systemSplashFmt:TextFormat = new TextFormat(corporateFontHeavy,systemSplashFontHeight);
      
      public static var systemSplashEmbed:Boolean = true;
      
      public static const windowTitleFontHeight:int = 14;
      
      public static const windowTitleFmt:TextFormat = new TextFormat(corporateFontHeavy,windowTitleFontHeight);
      
      public static var windowTitleEmbed:Boolean = true;
      
      public static const h1FontHeight:int = 17;
      
      public static const h1Fmt:TextFormat = new TextFormat(corporateFontHeavy,h1FontHeight);
      
      public static var h1Embed:Boolean = true;
      
      public static const h2FontHeight:int = 14;
      
      public static const h2Fmt:TextFormat = new TextFormat(corporateFontHeavy,h2FontHeight);
      
      public static var h2Embed:Boolean = true;
      
      public static const h3FontHeight:int = 12;
      
      public static const h3Fmt:TextFormat = new TextFormat(corporateFontHeavy,h3FontHeight);
      
      public static var h3Embed:Boolean = true;
      
      public static const plainBigFontHeight:int = 14;
      
      public static const plainBigFmt:TextFormat = new TextFormat(corporateFontHeavy,plainBigFontHeight);
      
      public static var plainBigEmbed:Boolean = true;
      
      public static const plainStdFontHeight:int = 12;
      
      public static const plainStdFmt:TextFormat = new TextFormat(corporateFontRegular,plainStdFontHeight);
      
      public static var plainStdEmbed:Boolean = true;
      
      public static const strongStdFontHeight:int = 12;
      
      public static const strongStdFmt:TextFormat = new TextFormat(corporateFontHeavy,strongStdFontHeight);
      
      public static var strongStdEmbed:Boolean = true;
      
      public static const centeredHeavyFontHeight:int = 12;
      
      public static const centeredHeavyFmt:TextFormat = new TextFormat(corporateFontHeavy,centeredHeavyFontHeight);
      
      public static var centeredHeavyEmbed:Boolean = true;
      
      public static const tradeWindowButtonFontHeight:int = 10;
      
      public static const tradeWindowButtonFmt:TextFormat = new TextFormat(corporateFontRegular,tradeWindowButtonFontHeight,16777215);
      
      public static var tradeWindowButtonEmbed:Boolean = true;
      
      public static const tooltipFontHeight:int = 12;
      
      public static const tooltipFmt:TextFormat = new TextFormat("Tahoma",tooltipFontHeight,13421772);
      
      public static const tooltipFmtDeviceFonts:TextFormat = new TextFormat(null,tooltipFontHeight,13421772);
      
      public static const tooltipEmbed:Boolean = false;
      
      public static const infoFieldFontHeight:int = 10;
      
      public static const infoFieldFmt:TextFormat = new TextFormat(corporateFontHeavy,infoFieldFontHeight,14671839);
      
      public static var infoFieldEmbed:Boolean = true;
      
      public static const infoFieldFixedFmt:TextFormat = new TextFormat(infoFieldFmt.font,infoFieldFmt.size,infoFieldFmt.color);
      
      public static const logFontHeight:int = 12;
      
      public static const logFmt:TextFormat = new TextFormat(corporateFontHeavy,logFontHeight,14671839);
      
      public static var logEmbed:Boolean = true;
      
      public static const achievementFontHeight:int = 11;
      
      public static const achievementFmt:TextFormat = new TextFormat(corporateFontRegular,achievementFontHeight,14671839);
      
      public static var achievementEmbed:Boolean = false;
      
      public static const companyHierarchyFontHeight:int = 11;
      
      public static const companyHierarchyFmt:TextFormat = new TextFormat(corporateFontRegularFlex,achievementFontHeight,14671839);
      
      public static const companyHierarchyHeadingsFmt:TextFormat = new TextFormat(corporateFontHeavyFlex,achievementFontHeight,14671839);
      
      public static const companyHierarchyEmbed:Boolean = false;
      
      public static const companyHierarchyColorGreyed:int = 8816248;
      
      public static const companyHierarchyColorBright:int = 15327936;
      
      public static const companyHierarchyColorHeading:int = 16763904;
      
      public static const achievementOfferFontHeight:int = 11;
      
      public static const achievementOfferFmt:TextFormat = new TextFormat(corporateFontRegular,achievementOfferFontHeight,14671839);
      
      public static const achievementOfferEmbed:Boolean = false;
      
      public static const simpleFontHeight:int = 14;
      
      public static const simpleFmt:TextFormat = new TextFormat(corporateFontHeavy,simpleFontHeight);
      
      public static const simpleFmtWhite:TextFormat = new TextFormat(corporateFontHeavy,simpleFontHeight,WHITE);
      
      public static var simpleEmbed:Boolean = true;
      
      public static const stdOffsetY:int = 0;
      
      public static const stdOffsetLogY:int = 0;
      
      public static const spaceballScoreFontHeight:int = 12;
      
      public static const spaceballScoreFmt:TextFormat = new TextFormat(corporateFontHeavy,spaceballScoreFontHeight,WHITE);
      
      public static var spaceballScoreEmbed:Boolean = true;
      
      public static const nickFontHeight:int = 13;
      
      public static const nickFmt:TextFormat = new TextFormat(deviceFontTahoma,nickFontHeight,null,true);
      
      public static var nickEmbed:Boolean = false;
      
      public static const systemTitleFontHeight:int = 13;
      
      public static const systemTitleFmt:TextFormat = new TextFormat(corporateFontMediumFlex,systemTitleFontHeight,16776960);
      
      public static var systemTitleEmbed:Boolean = true;
      
      public static const LIGHT_YELLOW_COLOR:uint = 15327936;
      
      public static const oreTradeElementFontHeight:int = 10;
      
      public static const oreTradeElementFmt:TextFormat = new TextFormat(corporateFontHeavy,oreTradeElementFontHeight,LIGHT_YELLOW_COLOR);
      
      public static var oreTradeElementEmbed:Boolean = true;
      
      public static const systemPermanentTitleFontHeight:int = 12;
      
      public static const systemPermanentTitleFmt:TextFormat = new TextFormat(corporateFontRegular,simpleFontHeight,14892454);
      
      public static var systemPermanentTitleEmbed:Boolean = true;
      
      public static const alternateDroneFontHeight:int = 10;
      
      public static const alternateDroneFmt:TextFormat = new TextFormat(corporateFontRegular,alternateDroneFontHeight,14671839);
      
      public static var alternateDroneEmbed:Boolean = true;
      
      public static const achievementUITitleFontHeight:int = 12;
      
      public static const achievementUIDescFontHeight:int = 11;
      
      public static const achievementUITitleFmt:TextFormat = new TextFormat(corporateFontHeavy,achievementUITitleFontHeight,16763904,false);
      
      public static const achievementUIDescriptionFmt:TextFormat = new TextFormat(corporateFontRegular,achievementUIDescFontHeight,15461355,false);
      
      public static var achievementUIEmbed:Boolean = true;
      
      public static const shipInfoTitleSymbolFmt:TextFormat = new TextFormat("Segoe UI Symbol",11,16776960);
      
      public static const shipInfoTitleSymbolEmbed:Boolean = false;
      
      public static const repairWindowTitleFontHeight:int = 16;
      
      public static const repairWindowKillNameFontHeight:int = 18;
      
      public static const repairWindowDescFontHeight:int = 14;
      
      public static const repairWindowDetailFontHeight:int = 13;
      
      public static const repairWindowPriceFontHeight:int = 15;
      
      public static const repairWindowRed:uint = 12320768;
      
      public static const repairWindowGreen:uint = 5157161;
      
      public static const repairWindowWhite:uint = 13421772;
      
      public static const repairWindowYellow:uint = 15580416;
      
      public static const repairWindowTitleFmt:TextFormat = new TextFormat(corporateFontHeavy,repairWindowTitleFontHeight,repairWindowRed,false,null,null,null,null,TextFormatAlign.CENTER);
      
      public static const repairWindowKillerFmt:TextFormat = new TextFormat(corporateFontHeavy,repairWindowKillNameFontHeight,repairWindowYellow,false);
      
      public static const repairWindowDescFmt:TextFormat = new TextFormat(corporateFontRegular,repairWindowDescFontHeight,repairWindowWhite,false,null,null,null,null,TextFormatAlign.CENTER);
      
      public static const repairWindowPriceFmt:TextFormat = new TextFormat(corporateFontRegular,repairWindowPriceFontHeight,repairWindowWhite,false);
      
      public static const repairWindowDetailFmt:TextFormat = new TextFormat(corporateFontRegular,repairWindowDetailFontHeight,repairWindowWhite,false,null,null,null,null,TextFormatAlign.CENTER);
      
      public static const repairWindowButtonFmt:TextFormat = new TextFormat(corporateFontHeavy,repairWindowDetailFontHeight,16777215,false);
      
      public static var repairWindowEmbed:Boolean = true;
      
      public static const warpWindowShipSelectorFontHeight:int = 12;
      
      public static const warpWindowShipSelectorFmt:TextFormat = new TextFormat(corporateFontRegular,warpWindowShipSelectorFontHeight,repairWindowWhite,false,null,null,null,null,TextFormatAlign.CENTER);
      
      public static const warpWindowWarpButtonFmt:TextFormat = new TextFormat(corporateFontHeavy,warpWindowShipSelectorFontHeight,repairWindowRed,false,null,null,null,null,TextFormatAlign.CENTER);
      
      public static const sectorControlTicketAmountsBgGrey:int = 5592405;
      
      public static const sectorControlTicketAmountsFontHeight:int = 10;
      
      public static const sectorControlPlayerAmountsGrey:int = 9934743;
      
      public static const sectorControlPlayerAmountsRed:int = 10639962;
      
      public static const sectorControlPlayerAmountsFontHeight:int = 12;
      
      public static const sectorControlProgressBarDirectionFontHeight:int = 10;
      
      public static const sectorControlTicketAmountsFmt:TextFormat = new TextFormat(corporateFontHeavy,sectorControlTicketAmountsFontHeight,sectorControlPlayerAmountsGrey,false,null,null,null,null,TextFormatAlign.LEFT);
      
      public static const sectorControlPlayerAmountsFmt:TextFormat = new TextFormat(corporateFontRegular,sectorControlPlayerAmountsFontHeight,sectorControlPlayerAmountsGrey,false,null,null,null,null,TextFormatAlign.RIGHT);
      
      public static const sectorControlMaxPlayerAmountsFmt:TextFormat = new TextFormat(corporateFontRegular,sectorControlPlayerAmountsFontHeight,sectorControlPlayerAmountsGrey,false,null,null,null,null,TextFormatAlign.LEFT);
      
      public static const sectorControlProgressBarDirectionFmt:TextFormat = new TextFormat(corporateFontHeavy,sectorControlProgressBarDirectionFontHeight,16777215,false,null,null,null,null,TextFormatAlign.CENTER);
      
      public static const jackpotWindowRoundFmt:TextFormat = new TextFormat(corporateFontExt,repairWindowKillNameFontHeight,repairWindowYellow,false);
      
      public static const clickIconFormat:TextFormat = new TextFormat(Styles.baseFont,12,Styles.repairWindowYellow,null,null,null,null,null,TextFormatAlign.CENTER,0,0);
      
      public static const clickIconFormatLockTimer:TextFormat = new TextFormat(Styles.baseFont,16,Styles.repairWindowWhite,null,null,null,null,null,TextFormatAlign.CENTER,0,0);
      
      public static const spaceMapFontSize:int = 10;
      
      public static const spaceMapFontColor:uint = 16777215;
      
      public static const spaceMapFontBold:Boolean = true;
      
      public static const spaceMapFontWidth:int = 30;
      
      public static const spaceMapFontHeight:int = 15;
      
      public static const spaceMapFontFmt:TextFormat = new TextFormat(deviceFontVerdana,spaceMapFontSize,spaceMapFontColor,spaceMapFontBold,null,null,null,null,TextFormatAlign.RIGHT);
      
      public static const ggBuilderH2FontHeight:int = 12;
      
      public static const ggBuilderH2Fmt:TextFormat = new TextFormat(corporateFontHeavy,ggBuilderH2FontHeight,8619658,null,null,null,null,null,TextFormatAlign.CENTER);
      
      public static var ggBuilderH2Embed:Boolean = true;
      
      public static const ggBuilderPlainStdFontHeight:int = 10;
      
      public static const ggBuilderPlainStdFmt:TextFormat = new TextFormat(corporateFontHeavy,ggBuilderPlainStdFontHeight);
      
      public static var ggBuilderPlainStdEmbed:Boolean = true;
      
      public static const ggBuilderPlainBigFontHeight:int = 14;
      
      public static const ggBuilderPlainBigFmt:TextFormat = new TextFormat(corporateFontRegular,ggBuilderPlainBigFontHeight);
      
      public static var ggBuilderPlainBigEmbed:Boolean = true;
      
      public static const ggBuilderH3Fmt:TextFormat = new TextFormat(corporateFontHeavy,ggBuilderPlainBigFontHeight);
      
      public static var ggBuilderH3Embed:Boolean = true;
      
      public static const multiplierLightFontHeight:int = 16;
      
      public static const multiplierLightFmt:TextFormat = new TextFormat(corporateFontHeavy,multiplierLightFontHeight,3815994,null,null,null,null,null,TextFormatAlign.CENTER);
      
      public static var multiplierLightEmbed:Boolean = true;
      
      public static const gateSelectorFontHeight:int = 12;
      
      public static const gateSelectorFmt:TextFormat = new TextFormat(corporateFontHeavy,gateSelectorFontHeight);
      
      public static var gateSelectorEmbed:Boolean = true;
      
      public static const centeredSmallFontHeight:int = 11;
      
      public static const centeredSmallFmt:TextFormat = new TextFormat(corporateFontHeavy,centeredSmallFontHeight,null,null,null,null,null,null,TextFormatAlign.CENTER);
      
      public static var centeredSmallEmbed:Boolean = true;
      
      public static const spinAmountLabelFontHeight:int = 10;
      
      public static const spinAmountLabelFmt:TextFormat = new TextFormat(deviceFontVerdana,spinAmountLabelFontHeight,10077678,null,null,null,null,null,TextFormatAlign.CENTER);
      
      public static var spinAmountLabelEmbed:Boolean = false;
      
      public static const spinAmountItemFmt:TextFormat = new TextFormat(deviceFontVerdana,centeredSmallFontHeight,8421504);
      
      public static var spinAmountItemEmbed:Boolean = false;
      
      public static const helpTextFmt:TextFormat = new TextFormat(deviceFontVerdana,centeredSmallFontHeight);
      
      public static var helpTextEmbed:Boolean = false;
      
      public static const bonusGateDescFmt:TextFormat = new TextFormat(deviceFontVerdana,centeredSmallFontHeight);
      
      public static var bonusGateDescEmbed:Boolean = false;
      
      public static const loadingFontHeight:int = 24;
      
      public static const loadingFmt:TextFormat = new TextFormat(corporateFontHeavy,loadingFontHeight,16434692,null,null,null,null,null,TextFormatAlign.CENTER);
      
      public static var loadingEmbed:Boolean = true;
      
      clientSelection.align = TextFormatAlign.CENTER;
      clientSelectionHeadline.bold = true;
      clientSelectionButton.align = TextFormatAlign.CENTER;
      clientSelectionButton2D.align = TextFormatAlign.CENTER;
      clientSelectionButton2D.underline = true;
      systemSplashFmt.align = TextFormatAlign.CENTER;
      centeredHeavyFmt.align = TextFormatAlign.CENTER;
      infoFieldFixedFmt.align = TextFormatAlign.RIGHT;
      spaceballScoreFmt.align = TextFormatAlign.CENTER;
      
      public function Styles()
      {
         super();
      }
      
      public static function useDeviceFonts() : void
      {
         baseEmbed = hsgHeadEmbed = hsgBodyEmbed = h1Embed = h2Embed = h3Embed = systemSplashEmbed = infoFieldEmbed = windowTitleEmbed = plainBigEmbed = plainStdEmbed = strongStdEmbed = centeredHeavyEmbed = plainBigEmbed = logEmbed = achievementEmbed = simpleEmbed = spaceballScoreEmbed = repairWindowEmbed = tradeWindowButtonEmbed = systemTitleEmbed = oreTradeElementEmbed = systemPermanentTitleEmbed = alternateDroneEmbed = achievementUIEmbed = false;
      }
      
      public static function distillAndWrite(param1:String, param2:TextField, param3:String = null, param4:TextFormat = null) : Boolean
      {
         var _loc8_:int = 0;
         if(param3 == null)
         {
            param3 = TextFieldAutoSize.LEFT;
         }
         var _loc5_:Number = param2.width;
         var _loc6_:Number = param2.height;
         param2.autoSize = param3;
         param2.text = param1;
         if(param4 != null)
         {
            param2.defaultTextFormat = param4;
         }
         if(param2.width <= _loc5_ && param2.height <= _loc6_)
         {
            return false;
         }
         var _loc7_:String = param1;
         while(param2.width > _loc5_ || param2.height > _loc6_)
         {
            _loc8_ = _loc7_.length;
            _loc7_ = _loc7_.substring(0,_loc8_ - 3) + "… ";
            param2.text = _loc7_;
         }
         return true;
      }
   }
}

