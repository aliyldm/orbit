package net.bigpoint.darkorbit.delete_in_eic
{
   import com.bigpoint.utils.BitmapAtlas;
   import com.bigpoint.utils.PointLite;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.fui.components.window.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.vo.FeatureWindowVO;
   
   public interface ISimpleWindow extends IWindow
   {
      
      function setTitle(param1:String, param2:Boolean = true) : void;
      
      function get position() : PointLite;
      
      function get size() : PointLite;
      
      function get width() : Number;
      
      function get height() : Number;
      
      function maximize(param1:Boolean = true, param2:Boolean = false) : void;
      
      function minimize(param1:Boolean = true, param2:Boolean = false) : void;
      
      function get maximized() : Boolean;
      
      function update(param1:FeatureWindowVO, param2:Boolean) : void;
      
      function initIcon(param1:String, param2:SWFFinisher = null, param3:BitmapAtlas = null) : void;
      
      function getUIContainer() : Sprite;
      
      function handleToFront() : void;
      
      function handleToBack() : void;
      
      function get isTweening() : Boolean;
      
      function get isTweaning() : Boolean;
   }
}

