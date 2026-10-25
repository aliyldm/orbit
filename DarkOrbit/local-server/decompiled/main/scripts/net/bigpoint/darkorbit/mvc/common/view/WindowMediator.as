package net.bigpoint.darkorbit.mvc.common.view
{
   import com.bigpoint.utils.PointLite;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.BattleStationBuildWindowView;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.BattleStationWindowViewMediator;
   import net.bigpoint.darkorbit.mvc.common.utils.ScreenScaleUtils;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOWindow;
   import net.bigpoint.darkorbit.mvc.companyhierarchy.view.CompanyHierarchyWindowMediator;
   import net.bigpoint.darkorbit.mvc.companyhierarchy.view.components.CompanyHierarchyWindowView;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.questWindow.model.QuestProxy;
   import net.bigpoint.darkorbit.mvc.questWindow.view.QuestGiverWindowMediator;
   import net.bigpoint.darkorbit.mvc.questWindow.view.components.QuestGiverWindowView;
   import org.puremvc.as3.multicore.interfaces.IMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import spark.components.SkinnableContainer;
   
   public class WindowMediator extends DOAbstractMediator implements IMediator
   {
      
      public static const NAME:String = "WindowMediator";
      
      private var windowManager:FlexWindowManager;
      
      public function WindowMediator(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
         this.windowManager = FlexWindowManager.getInstance();
         this.windowManager.init(this.windowContainer);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [GuiNotifications.CLOSE_WINDOW_BY_TYPE,GuiNotifications.OPEN_QUEST_WINDOW,GuiNotifications.OPEN_BATTLE_STATION_WINDOW,GuiNotifications.OPEN_COMPANY_HIERARCHY_WINDOW,GuiNotifications.CLOSE_QUEST_WINDOW,GuiNotifications.CLOSE_ALL_FLEX_WINDOWS,GuiNotifications.UPDATE_WINDOWS_POSITIONS];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:QuestGiverWindowView = null;
         var _loc8_:QuestGiverWindowMediator = null;
         var _loc9_:BattleStationBuildWindowView = null;
         var _loc10_:IMediator = null;
         var _loc11_:CompanyHierarchyWindowView = null;
         var _loc12_:QuestProxy = null;
         var _loc3_:String = param1.getName();
         _loc4_ = param1.getBody();
         switch(_loc3_)
         {
            case GuiNotifications.CLOSE_WINDOW_BY_TYPE:
               this.windowManager.destroyWindow(String(_loc4_));
               sendNotification(GuiNotifications.NOTIFY_WINDOW_TYPE_CLOSED + String(_loc4_));
               break;
            case GuiNotifications.CREATE_POP_UP:
               _loc5_ = _loc4_.popUpType;
               this.windowManager.createWindow(_loc5_);
               break;
            case GuiNotifications.OPEN_QUEST_WINDOW:
               facade.removeMediator(QuestGiverWindowMediator.NAME);
               _loc6_ = _loc4_ as int;
               _loc7_ = QuestGiverWindowView(this.windowManager.createWindow(FlexWindowManager.QUEST_GIVER_WINDOW));
               _loc8_ = new QuestGiverWindowMediator(_loc7_);
               _loc8_.questGiverID = _loc6_;
               facade.registerMediator(_loc8_);
               if(_loc4_ != null)
               {
                  _loc12_ = facade.retrieveProxy(QuestProxy.NAME) as QuestProxy;
                  if(_loc12_)
                  {
                     _loc12_.tryToPopulateQuestGiverWindow();
                  }
               }
               break;
            case GuiNotifications.OPEN_BATTLE_STATION_WINDOW:
               if(facade.hasMediator(BattleStationWindowViewMediator.NAME))
               {
                  facade.removeMediator(BattleStationWindowViewMediator.NAME);
               }
               _loc9_ = BattleStationBuildWindowView(this.windowManager.createWindow(FlexWindowManager.BATTLE_STATION_BUILD_WINDOW,FlexWindowManager.WINDOW_RIGHT_ALIGNED));
               _loc9_.setWindowMode(_loc4_ as String);
               _loc10_ = new BattleStationWindowViewMediator(_loc9_);
               facade.registerMediator(_loc10_);
               break;
            case GuiNotifications.OPEN_COMPANY_HIERARCHY_WINDOW:
               if(facade.hasMediator(CompanyHierarchyWindowMediator.NAME))
               {
                  facade.removeMediator(CompanyHierarchyWindowMediator.NAME);
               }
               _loc11_ = CompanyHierarchyWindowView(this.windowManager.createWindow(FlexWindowManager.COMPANY_HIERARCHY_WINDOW));
               facade.registerMediator(new CompanyHierarchyWindowMediator(_loc11_));
               break;
            case GuiNotifications.CLOSE_QUEST_WINDOW:
               this.windowManager.destroyWindow(FlexWindowManager.QUEST_GIVER_WINDOW);
               sendNotification(GuiNotifications.NOTIFY_WINDOW_TYPE_CLOSED + FlexWindowManager.QUEST_GIVER_WINDOW);
               facade.removeMediator(QuestGiverWindowMediator.NAME);
               break;
            case GuiNotifications.CLOSE_ALL_FLEX_WINDOWS:
               this.windowManager.destroyAllWindows();
               break;
            case GuiNotifications.UPDATE_WINDOWS_POSITIONS:
               this.updateWindowsPositions();
         }
      }
      
      private function updateWindowsPositions() : void
      {
         var _loc1_:String = null;
         var _loc2_:DOWindow = null;
         var _loc3_:PointLite = null;
         var _loc4_:PointLite = null;
         for(_loc1_ in this.windowManager.windowList)
         {
            _loc2_ = this.windowManager.windowList[_loc1_] as DOWindow;
            _loc3_ = new PointLite(_loc2_.x,_loc2_.y);
            if(_loc2_)
            {
               _loc4_ = ScreenScaleUtils.getScalePosition(screenManager.viewportResizeValues.beforeResize,new PointLite(screenManager.stageWidth,screenManager.stageHeight),_loc3_,new PointLite(_loc2_.width,_loc2_.height));
               _loc4_ = ScreenScaleUtils.correctOutsideViewportPosition(new Rectangle(_loc4_.x,_loc4_.y,_loc2_.width,_loc2_.height),new PointLite(screenManager.stageWidth,screenManager.stageHeight));
            }
            _loc2_.x = _loc4_.x;
            _loc2_.y = _loc4_.y;
         }
      }
      
      protected function get windowContainer() : SkinnableContainer
      {
         return viewComponent as SkinnableContainer;
      }
   }
}

