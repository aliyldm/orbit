package net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces
{
   import com.bigpoint.utils.BitmapAtlas;
   import com.bigpoint.utils.PointLite;
   import flash.display.Sprite;
   import flash.events.IEventDispatcher;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.vo.FeatureWindowVO;
   
   public interface IWindow extends IEventDispatcher
   {
      
      function get id() : String;
      
      function setTitle(param1:String, param2:Boolean = true) : void;
      
      function set x(param1:Number) : void;
      
      function set y(param1:Number) : void;
      
      function get position() : PointLite;
      
      function setSize(param1:Number, param2:Number) : void;
      
      function get size() : PointLite;
      
      function get width() : Number;
      
      function get height() : Number;
      
      function maximize(param1:Boolean = true, param2:Boolean = false) : void;
      
      function minimize(param1:Boolean = true, param2:Boolean = false) : void;
      
      function get maximized() : Boolean;
      
      function update(param1:FeatureWindowVO, param2:Boolean) : void;
      
      function initIcon(param1:String, param2:SWFFinisher = null, param3:BitmapAtlas = null) : void;
      
      function getUIContainer() : Sprite;
      
      function showInProgressOverlay() : void;
      
      function hideInProgressOverlay() : void;
      
      function isTweening() : Boolean;
      
      function cleanup(param1:Boolean = true) : void;
      
      function loadAndBuildUI(param1:String, param2:Function = null, ... rest) : void;
   }
}

