package net.bigpoint.darkorbit.map.model.traits.hud
{
   import com.bigpoint.utils.bindables.BindableCountDown;
   
   public class TimerIconTrait extends IconTrait
   {
      
      public const seconds:BindableCountDown = new BindableCountDown();
      
      public function TimerIconTrait(param1:int = 0, param2:String = "")
      {
         this.seconds.value = param1;
         super(param2);
      }
   }
}

