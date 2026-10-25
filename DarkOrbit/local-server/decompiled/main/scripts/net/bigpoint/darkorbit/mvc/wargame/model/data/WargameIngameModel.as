package net.bigpoint.darkorbit.mvc.wargame.model.data
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.bigpoint.utils.bindables.BindableCountDown;
   import com.bigpoint.utils.bindables.BindableInt;
   import com.bigpoint.utils.bindables.BindableNumber;
   import com.bigpoint.utils.bindables.BindableString;
   
   public class WargameIngameModel
   {
      
      public const team:BindableString = new BindableString();
      
      public const teamRedScore:BindableInt = new BindableInt();
      
      public const teamBlueScore:BindableInt = new BindableInt();
      
      public const teamRedMemberCount:BindableInt = new BindableInt();
      
      public const teamBlueMemberCount:BindableInt = new BindableInt();
      
      public const score:BindableInt = new BindableInt();
      
      public const remainingLives:BindableInt = new BindableInt();
      
      public const waveCount:BindableInt = new BindableInt();
      
      public const isInvading:BindableBoolean = new BindableBoolean();
      
      public const invasionTimer:BindableNumber = new BindableCountDown();
      
      public function WargameIngameModel()
      {
         super();
         this.invasionTimer.minValue = 0;
      }
   }
}

