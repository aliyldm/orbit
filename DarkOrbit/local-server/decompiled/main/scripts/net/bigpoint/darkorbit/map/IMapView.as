package net.bigpoint.darkorbit.map
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.Map;
   import org.osflash.signals.IOnceSignal;
   
   public interface IMapView
   {
      
      function get ready() : IOnceSignal;
      
      function load(param1:Map) : void;
      
      function setViewportSize(param1:int, param2:int) : void;
      
      function update(param1:int, param2:int, param3:Number) : void;
      
      function screen2game(param1:int, param2:int, param3:PointLite = null) : PointLite;
      
      function game2screen(param1:int, param2:int, param3:int = 0, param4:PointLite = null) : PointLite;
      
      function zoomIn(param1:Number = 0.3) : void;
      
      function zoomOut(param1:Number = 0.3) : void;
      
      function zoomTo(param1:Number, param2:Number) : void;
      
      function restoreUserZoom(param1:Number) : void;
      
      function get zoom() : Number;
      
      function dispose() : void;
      
      function addUpdatable(param1:IUpdatable) : void;
      
      function removeUpdatable(param1:IUpdatable) : void;
      
      function get readyRequestType() : uint;
      
      function toString() : String;
   }
}

