package net.bigpoint.darkorbit.map.model.minimap
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.com.module.PingPositionRequest;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.managers.EasterEggPingManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.groupsystem.model.proxy.GroupProxy;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class MinimapMediator extends DOAbstractMediator
   {
      
      public static const NAME:String = "MinimapMediator";
      
      private static const WINDOW_EDGE_BUFFER:Number = -30;
      
      private var _minimapWindow:SimpleWindow;
      
      private var _miniMap:MiniMap;
      
      public function MinimapMediator(param1:MiniMap)
      {
         super(NAME,param1);
         this._miniMap = param1;
         this._miniMap.resized.add(this.handleMiniMapSizeChanged);
         this._miniMap.clicked.add(this.handleMapClick);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this._minimapWindow = guiManager.getWindow(GuiConstants.MINIMAP_WINDOW);
         if(this._minimapWindow == null && Settings.createMinimap)
         {
            this._minimapWindow = guiManager.createWindow(GuiConstants.MINIMAP_WINDOW,SimpleWindowCreationMap.getById(GuiConstants.MINIMAP_WINDOW)) as SimpleWindow;
         }
         this._minimapWindow.addEventListener(SimpleWindowEvent.ZOOM_IN,this.zoomIn);
         this._minimapWindow.addEventListener(SimpleWindowEvent.ZOOM_OUT,this.zoomOut);
         this._miniMap.x = 30;
         this._miniMap.y = 20;
         this._minimapWindow.getRootContainer().addChild(this._miniMap);
         this.handleMiniMapSizeChanged();
      }
      
      public function get miniMap() : MiniMap
      {
         return this._miniMap;
      }
      
      private function zoomIn(param1:SimpleWindowEvent) : void
      {
         this._miniMap.zoomIn();
      }
      
      private function zoomOut(param1:SimpleWindowEvent) : void
      {
         this._miniMap.zoomOut();
      }
      
      private function handleMiniMapSizeChanged() : void
      {
         this._minimapWindow.setSize(this._miniMap.miniMapWidth + 25,this._miniMap.miniMapHeight + 45);
         this.checkMiniMapIsInsideClientBounds(this._minimapWindow);
      }
      
      private function checkMiniMapIsInsideClientBounds(param1:SimpleWindow) : void
      {
         var _loc2_:Number = ScreenManager.getScreenWidth();
         var _loc3_:Number = ScreenManager.getScreenHeight();
         var _loc4_:int = _loc2_ - (param1.resizeDimension.x + WINDOW_EDGE_BUFFER);
         var _loc5_:int = _loc3_ - (param1.resizeDimension.y + WINDOW_EDGE_BUFFER);
         if(param1.x > _loc4_)
         {
            param1.x = _loc4_;
         }
         if(param1.y > _loc5_)
         {
            param1.y = _loc5_;
         }
         param1.x = Math.max(20,param1.x);
         param1.y = Math.max(20,param1.y);
      }
      
      private function handleMapClick(param1:int, param2:int) : void
      {
         if(Boolean(this.groupProxy) && this.groupProxy.pingMode)
         {
            this.groupProxy.pingMode = false;
            GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new PingPositionRequest(param1,param2));
            EasterEggPingManager.getInstance().checkPingPattern(new PointLite(param1,param2),this.miniMap.map);
         }
         else if(!ScreenManager.getInstance().eventManager.isControlsLocked())
         {
            ScreenManager.getInstance().eventManager.moveHeroToCordinates(param1,param2);
         }
      }
      
      private function get groupProxy() : GroupProxy
      {
         return GameFacade.getInstance().retrieveProxy(GroupProxy.NAME) as GroupProxy;
      }
   }
}

