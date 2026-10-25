package net.bigpoint.darkorbit.fui.components.window
{
   import com.bigpoint.utils.BitmapAtlas;
   import com.bigpoint.utils.PointLite;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.delete_in_eic.ISimpleWindow;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.vo.FeatureWindowVO;
   
   public class Window extends Container implements ISimpleWindow
   {
      
      public function Window()
      {
         super();
      }
      
      public function get id() : String
      {
         return "";
      }
      
      public function get position() : PointLite
      {
         return null;
      }
      
      public function get size() : PointLite
      {
         return null;
      }
      
      public function get maximized() : Boolean
      {
         return false;
      }
      
      public function update(param1:FeatureWindowVO, param2:Boolean) : void
      {
      }
      
      public function maximize(param1:Boolean = true, param2:Boolean = false) : void
      {
      }
      
      public function minimize(param1:Boolean = true, param2:Boolean = false) : void
      {
      }
      
      public function setTitle(param1:String, param2:Boolean = true) : void
      {
      }
      
      public function setWindowDimension(param1:PointLite) : void
      {
      }
      
      public function initIcon(param1:String, param2:SWFFinisher = null, param3:BitmapAtlas = null) : void
      {
      }
      
      public function get isTweening() : Boolean
      {
         return false;
      }
      
      public function get isTweaning() : Boolean
      {
         return false;
      }
      
      public function refreshWindow() : void
      {
      }
      
      public function showInProgressOverlay() : void
      {
      }
      
      public function hideInProgressOverlay() : void
      {
      }
      
      public function getUIContainer() : Sprite
      {
         return null;
      }
      
      public function handleToFront() : void
      {
      }
      
      public function handleToBack() : void
      {
      }
   }
}

