package net.bigpoint.darkorbit.mvc.sectorControl.controller
{
   import com.greensock.TweenMax;
   import net.bigpoint.darkorbit.com.module.FactionModule;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.minimap.MarkerVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.sectorControl.map.ControlPoint;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class PingUnstableSectorsCommand extends DOAbstractSimpleCommand
   {
      
      private static const COLORS:Array = [];
      
      COLORS[FactionModule.FACTION_NONE] = "white";
      COLORS[FactionModule.FACTION_MMO] = "red";
      COLORS[FactionModule.FACTION_EIC] = "blue";
      COLORS[FactionModule.FACTION_VRU] = "green";
      
      public function PingUnstableSectorsCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:MapEntity = null;
         if(ScreenManager.getInstance().map)
         {
            for each(_loc2_ in ScreenManager.getInstance().map.entities)
            {
               if(_loc2_ is ControlPoint)
               {
                  this.pingMiniMap(_loc2_ as ControlPoint);
               }
            }
         }
      }
      
      private function pingMiniMap(param1:ControlPoint) : void
      {
         var _loc4_:int = 0;
         var _loc2_:Vector.<FactionModule> = Vector.<FactionModule>(param1.invaders.value);
         var _loc3_:int = int(_loc2_.length);
         if(param1.isPingAllowed())
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               TweenMax.delayedCall(_loc4_ * 0.7,screenManager.minimap.addMapMarker,[new MarkerVO("sector_" + param1.id.toString(),param1.position.x,param1.position.y,1,"SC_" + this.getColorstring(_loc2_[_loc4_]),2,1,true)]);
               _loc4_++;
            }
         }
      }
      
      private function getColorstring(param1:FactionModule) : String
      {
         return COLORS[param1.faction] || COLORS[FactionModule.FACTION_NONE];
      }
   }
}

