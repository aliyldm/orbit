package net.bigpoint.darkorbit.map.model.traits.hud
{
   import com.bigpoint.utils.bindables.BindableInt;
   import com.bigpoint.utils.bindables.BindableNumber;
   
   public class ScoremageddonIconTrait extends IconTrait
   {
      
      public const livesLeft:BindableInt = new BindableInt();
      
      public const livesMax:BindableInt = new BindableInt();
      
      public const combo:BindableNumber = new BindableNumber();
      
      public const comboMax:BindableNumber = new BindableNumber();
      
      public function ScoremageddonIconTrait()
      {
         super();
      }
   }
}

