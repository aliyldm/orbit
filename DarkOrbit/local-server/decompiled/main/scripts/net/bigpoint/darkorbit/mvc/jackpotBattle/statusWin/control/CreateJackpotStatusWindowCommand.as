package net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.control
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.ArenaStatusCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.common.AssetNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.external.ExternalLoadVo;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.JackpotStatusConstants;
   import net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.model.JackpotStatusProxy;
   import net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.model.JackpotStatusUiVO;
   import net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.model.JackpotTimeVo;
   import net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.view.decorator.JackpotStatusUiDecorator;
   import net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.view.mediator.JackPotStatusUiMediator;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.MapAssetNotification;
   import net.bigpoint.darkorbit.mvc.mapElements.common.model.assetProxy.MapAssetLoadVo;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.utils.WebsiteAssetUtils;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CreateJackpotStatusWindowCommand extends DOAbstractSimpleCommand
   {
      
      public function CreateJackpotStatusWindowCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc6_:SimpleWindow = null;
         super.execute(param1);
         var _loc2_:ArenaStatusCommand = param1.getBody() as ArenaStatusCommand;
         var _loc3_:JackPotStatusUiMediator = facade.retrieveMediator(JackPotStatusUiMediator.NAME) as JackPotStatusUiMediator;
         if(!_loc3_)
         {
            _loc6_ = guiProxy.getWindowById(GuiConstants.JACKPOT_STATUS_UI_WINDOW);
            if(!_loc6_)
            {
               sendNotification(GuiNotifications.CREATE_WINDOW,GuiConstants.JACKPOT_STATUS_UI_WINDOW);
               _loc6_ = guiProxy.getWindowById(GuiConstants.JACKPOT_STATUS_UI_WINDOW);
            }
            _loc3_ = new JackPotStatusUiMediator(new JackpotStatusUiDecorator(_loc6_));
            facade.registerMediator(_loc3_);
         }
         var _loc4_:JackpotStatusProxy = facade.retrieveProxy(JackpotStatusProxy.NAME) as JackpotStatusProxy;
         var _loc5_:JackpotTimeVo = new JackpotTimeVo(_loc2_.secondsLeftInPhase,_loc2_.warpWarningOffsetSeconds);
         if(!_loc4_)
         {
            _loc4_ = new JackpotStatusProxy();
            facade.registerProxy(_loc4_);
         }
         _loc4_.setData(_loc5_);
         _loc3_.data = this.getVO(_loc2_);
         this.loadSwf(_loc3_);
         this.loadHeroPic(Hero.userID,_loc3_);
         this.loadOpponentPic(_loc2_.opponentId,_loc3_,_loc2_.opponentInstanceId);
      }
      
      private function getVO(param1:ArenaStatusCommand) : JackpotStatusUiVO
      {
         var _loc2_:JackpotStatusUiVO = new JackpotStatusUiVO();
         _loc2_.rightUserName = this.getOpponentName(param1);
         _loc2_.leftUserName = Hero.username;
         _loc2_.registerdUsersCount = param1.survivors;
         _loc2_.registerdUsersTotal = param1.participants;
         _loc2_.remainingTime = param1.secondsLeftInPhase;
         _loc2_.roundCount = param1.currentRound;
         _loc2_.matchType = param1.status;
         return _loc2_;
      }
      
      private function getOpponentName(param1:ArenaStatusCommand) : String
      {
         var _loc2_:String = null;
         switch(param1.opponentId)
         {
            case JackpotStatusConstants.UNKNOWN_PLAYER_ID:
               _loc2_ = BPLocale.getItem("jackpot_status_window_avatar_unknown");
               break;
            case JackpotStatusConstants.WILDCARD_ID:
               _loc2_ = BPLocale.getItem("jackpot_status_window_avatar_wildcard");
               break;
            default:
               _loc2_ = param1.opponentName;
         }
         return _loc2_;
      }
      
      private function loadOpponentPic(param1:int, param2:JackPotStatusUiMediator, param3:int) : void
      {
         var _loc4_:String = null;
         switch(param1)
         {
            case JackpotStatusConstants.UNKNOWN_PLAYER_ID:
               sendNotification(MapAssetNotification.LOAD_GRAPHICS_FOR_MAPASSET,new MapAssetLoadVo(param2.unknownPicLoaded,JackpotStatusConstants.LIB_ID,new <String>[JackpotStatusConstants.UNKNOWN],Bitmap));
               break;
            case JackpotStatusConstants.WILDCARD_ID:
               sendNotification(MapAssetNotification.LOAD_GRAPHICS_FOR_MAPASSET,new MapAssetLoadVo(param2.wildcardPicLoaded,JackpotStatusConstants.LIB_ID,new <String>[JackpotStatusConstants.WILDCARD],Bitmap));
               break;
            default:
               _loc4_ = WebsiteAssetUtils.generateUserPicLoadUrl(param1,param3,Settings.dynamicHost);
               sendNotification(AssetNotifications.LOAD_EXTERNAL,new ExternalLoadVo(_loc4_,param2.handleOpponentPicLoaded));
         }
      }
      
      private function loadHeroPic(param1:int, param2:JackPotStatusUiMediator) : void
      {
         var _loc3_:String = WebsiteAssetUtils.generateUserPicLoadUrl(param1,Settings.instanceID,Settings.dynamicHost);
         sendNotification(AssetNotifications.LOAD_EXTERNAL,new ExternalLoadVo(_loc3_,param2.handleHeroPicLoaded));
      }
      
      private function loadSwf(param1:JackPotStatusUiMediator) : void
      {
         sendNotification(MapAssetNotification.LOAD_GRAPHICS_FOR_MAPASSET,new MapAssetLoadVo(param1.handleFrameLoaded,JackpotStatusConstants.LIB_ID,new <String>[JackpotStatusConstants.FRAME],BitmapData));
         sendNotification(MapAssetNotification.LOAD_GRAPHICS_FOR_MAPASSET,new MapAssetLoadVo(param1.handleVSLogoLoaded,JackpotStatusConstants.LIB_ID,new <String>[JackpotStatusConstants.VS_ING],Bitmap));
      }
   }
}

