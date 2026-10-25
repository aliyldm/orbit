package net.bigpoint.darkorbit.net
{
   import com.bigpoint.utils.PointLite;
   import com.greensock.TweenLite;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.PointingArrowEffect;
   import net.bigpoint.darkorbit.map.model.minimap.MapMarker;
   import net.bigpoint.darkorbit.map.model.minimap.MarkerVO;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   
   public class UserInterfaceAssembly extends BaseAssembly
   {
      
      private static var _instance:UserInterfaceAssembly;
      
      private var facade:GameFacade;
      
      private var delegateDict:Dictionary;
      
      private var lockedShip:Ship;
      
      public function UserInterfaceAssembly(param1:Function)
      {
         super();
         if(param1 !== hidden)
         {
            throw new Error("UserInterfaceAssembly is a Singleton and can only be accessed through UserInterfaceAssembly.getInstance()");
         }
         this.facade = GameFacade.getInstance();
         this.initDelegateDict();
      }
      
      public static function getInstance() : UserInterfaceAssembly
      {
         if(_instance == null)
         {
            _instance = new UserInterfaceAssembly(hidden);
         }
         return _instance;
      }
      
      private static function hidden() : void
      {
      }
      
      private function initDelegateDict() : void
      {
         this.delegateDict = new Dictionary();
         this.delegateDict[ServerCommands.MINIMAP] = this.assembleMinimapCommand;
         this.delegateDict[ServerCommands.ARROW] = this.assembleArrowCommand;
         this.delegateDict[ServerCommands.WINDOW] = this.assembleWindowCommand;
         this.delegateDict[ServerCommands.BUTTON] = this.assembleButtonCommand;
      }
      
      public function assembleCommand(param1:Array) : void
      {
         var _loc2_:String = param1[2];
         if(this.delegateDict[_loc2_] != null)
         {
            this.delegateDict[_loc2_](param1);
         }
      }
      
      private function assembleButtonCommand(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc3_:Map = this.screenManager.map;
         var _loc4_:int = 0;
         switch(param1[3])
         {
            case ServerCommands.SHOW_FLASH:
               _loc5_ = int(param1[4]);
               _loc6_ = Boolean(int(param1[5]));
               if(_loc3_ != null)
               {
                  _loc4_ = 6;
                  while(_loc4_ < param1.length)
                  {
                     _loc2_ = int(param1[_loc4_]);
                     _loc4_++;
                  }
               }
               break;
            case ServerCommands.HIDE_FLASH:
         }
      }
      
      private function assembleWindowCommand(param1:Array) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         switch(param1[3])
         {
            case ServerCommands.MAXIMIZE_WINDOW:
               _loc3_ = 4;
               while(_loc3_ < param1.length)
               {
                  _loc2_ = String(param1[_loc3_]);
                  this.guiManager.maximizeWindow(_loc2_);
                  _loc3_++;
               }
         }
      }
      
      private function assembleArrowCommand(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         switch(param1[3])
         {
            case ServerCommands.SHOW_ARROW:
               _loc2_ = int(param1[4]);
               _loc3_ = int(param1[5]);
               map.effects.addEffectOnce(new PointingArrowEffect(map.hero.position,new PointLite(_loc2_,_loc3_)));
               break;
            case ServerCommands.HIDE_ARROW:
               map.effects.removeEffectFromMapObject(map.hero.id,EffectIDList.POINTING_ARROW);
         }
      }
      
      private function assembleMinimapCommand(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc2_:Map = this.screenManager.map;
         if(_loc2_ == null)
         {
            return;
         }
         switch(param1[3])
         {
            case ServerCommands.NOISE:
               ScreenManager.getInstance().minimap.startInterference(int(param1[4]));
               break;
            case ServerCommands.SHOW_MARKER:
               _loc4_ = int(param1[5]);
               _loc5_ = int(param1[6]);
               _loc6_ = int(param1[7]);
               _loc7_ = "";
               if(param1.length > 8)
               {
                  _loc7_ = param1[8];
                  if(_loc7_ != "_red")
                  {
                     _loc7_ = "";
                  }
               }
               ScreenManager.getInstance().minimap.addMapMarker(new MarkerVO(param1[4],_loc4_,_loc5_,_loc6_,_loc7_));
               break;
            case ServerCommands.HIDE_MARKER:
               MapMarker.stopMapMarker(param1[4]);
         }
      }
      
      public function moveCameraToCoordinates(param1:int, param2:int, param3:Number) : void
      {
         var _loc4_:Map = this.screenManager.map;
         if(_loc4_ != null)
         {
            this.screenManager.mapView.zoomTo(1,param3);
            this.screenManager.eventManager.lockControls();
            ScreenManager.cameraLock = ScreenManager.CAMERA_TWEENING_TO_COORDINATE;
            TweenLite.to(ScreenManager.camera,param3,{
               "x":param1,
               "y":param2,
               "onComplete":this.handleTweenToCoordinate
            });
         }
      }
      
      public function moveCameraToHero() : void
      {
         var _loc2_:Ship = null;
         if(ScreenManager.cameraLock == ScreenManager.CAMERA_TWEENING_TO_HERO || ScreenManager.cameraLock == ScreenManager.CAMERA_LOCKED_TO_HERO)
         {
            return;
         }
         var _loc1_:Map = this.screenManager.map;
         if(_loc1_ != null)
         {
            ScreenManager.cameraLock = ScreenManager.CAMERA_TWEENING_TO_HERO;
            _loc2_ = _loc1_.hero;
            TweenLite.to(ScreenManager.camera,3,{
               "x":_loc2_.x,
               "y":_loc2_.y,
               "onComplete":this.handleTweenToHero
            });
            this.screenManager.mapView.restoreUserZoom(1);
         }
      }
      
      public function moveCameraToShip(param1:int, param2:Number, param3:Number) : void
      {
         var _loc4_:Map = this.screenManager.map;
         if(_loc4_ != null)
         {
            if(ScreenManager.cameraLock == ScreenManager.CAMERA_TWEENING_TO_SHIP || ScreenManager.cameraLock == ScreenManager.CAMERA_LOCKED_TO_SHIP)
            {
               if(this.lockedShip != null && this.lockedShip.id == param1)
               {
                  this.screenManager.mapView.zoomTo(param2,param3);
                  return;
               }
            }
            this.screenManager.mapView.zoomTo(param2,param3);
            ScreenManager.cameraLock = ScreenManager.CAMERA_TWEENING_TO_SHIP;
            this.lockedShip = _loc4_.getShipManager().getShip(param1);
            TweenLite.to(ScreenManager.camera,param3,{
               "dynamicProps":{
                  "x":this.getLockedShipXPos,
                  "y":this.getLockedShipYPos
               },
               "onComplete":this.handleTweenToShip,
               "onCompleteParams":[this.lockedShip]
            });
         }
      }
      
      private function handleTweenToShip(param1:Ship) : void
      {
         ScreenManager.lockedShipUserID = param1.id;
         ScreenManager.cameraLock = ScreenManager.CAMERA_LOCKED_TO_SHIP;
      }
      
      private function handleTweenToCoordinate() : void
      {
         ScreenManager.lockedShipUserID = -1;
         ScreenManager.cameraLock = ScreenManager.CAMERA_LOCKED_TO_COORDINATE;
      }
      
      private function handleTweenToHero() : void
      {
         this.screenManager.eventManager.unlockControls();
         ScreenManager.lockedShipUserID = -1;
         this.lockedShip = null;
         ScreenManager.cameraLock = ScreenManager.CAMERA_LOCKED_TO_HERO;
      }
      
      private function getLockedShipXPos() : Number
      {
         return this.lockedShip.x;
      }
      
      private function getLockedShipYPos() : Number
      {
         return this.lockedShip.y;
      }
      
      private function get screenManager() : ScreenManager
      {
         return ScreenManager.getInstance();
      }
      
      private function get guiManager() : GuiManager
      {
         return GuiManager.instance;
      }
   }
}

