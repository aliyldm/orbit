package net.bigpoint.darkorbit.map.model.traits.weapons
{
   import net.bigpoint.darkorbit.map.model.traits.AttackerTrait;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class AbstractWeapons
   {
      
      public var attackAnimationName:String = "attackLaser";
      
      public var owner:AttackerTrait;
      
      public const fire:ISignal = new Signal();
      
      public function AbstractWeapons()
      {
         super();
      }
   }
}

