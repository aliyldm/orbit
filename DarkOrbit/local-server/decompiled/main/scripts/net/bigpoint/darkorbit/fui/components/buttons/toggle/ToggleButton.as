package net.bigpoint.darkorbit.fui.components.buttons.toggle
{
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   
   public class ToggleButton extends Coreponent
   {
      
      public function ToggleButton()
      {
         super();
      }
      
      public function set xactive(param1:Number) : void
      {
         var _loc2_:IToggleButtonSkin = null;
         if(skin)
         {
            _loc2_ = skin as IToggleButtonSkin;
            _loc2_.xactive = param1;
         }
      }
      
      public function set xdeactive(param1:Number) : void
      {
         var _loc2_:IToggleButtonSkin = null;
         if(skin)
         {
            _loc2_ = skin as IToggleButtonSkin;
            _loc2_.xdeactive = param1;
         }
      }
      
      public function set duration(param1:Number) : void
      {
         var _loc2_:IToggleButtonSkin = null;
         if(skin)
         {
            _loc2_ = skin as IToggleButtonSkin;
            _loc2_.duration = param1;
         }
      }
      
      public function changeState() : void
      {
         var _loc1_:IToggleButtonSkin = null;
         if(skin)
         {
            _loc1_ = skin as IToggleButtonSkin;
            _loc1_.changeState();
         }
      }
      
      public function deactivate() : void
      {
         var _loc1_:IToggleButtonSkin = null;
         if(skin)
         {
            _loc1_ = skin as IToggleButtonSkin;
            _loc1_.deactivate();
         }
      }
      
      public function activate() : void
      {
         var _loc1_:IToggleButtonSkin = null;
         if(skin)
         {
            _loc1_ = skin as IToggleButtonSkin;
            _loc1_.activate();
         }
      }
   }
}

