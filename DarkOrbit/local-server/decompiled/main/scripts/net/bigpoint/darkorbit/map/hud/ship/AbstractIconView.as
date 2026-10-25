package net.bigpoint.darkorbit.map.hud.ship
{
   import flash.display.Sprite;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class AbstractIconView extends Sprite
   {
      
      public const sizeChanged:ISignal = new Signal();
      
      public function AbstractIconView()
      {
         super();
      }
   }
}

