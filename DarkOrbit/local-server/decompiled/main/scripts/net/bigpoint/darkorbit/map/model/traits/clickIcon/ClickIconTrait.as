package net.bigpoint.darkorbit.map.model.traits.clickIcon
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.bigpoint.utils.bindables.BindableInt;
   import com.bigpoint.utils.bindables.BindablePointLite;
   import com.bigpoint.utils.bindables.BindableString;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.model.traits.MouseHitAreaTrait;
   import net.bigpoint.darkorbit.map.model.traits.clickIcon.action.IMapEntityAction;
   import net.bigpoint.darkorbit.pattern.FullResourcePattern;
   
   public class ClickIconTrait extends MouseHitAreaTrait
   {
      
      private static const LOW_CLICK_PRIO:int = 0;
      
      private static const HIGH_CLICK_PRIO:int = 10;
      
      public static const TEXTFORMAT_ID_STANDART:int = 0;
      
      public static const TEXTFORMAT_ID_TIMER:int = 1;
      
      public const textFormatId:BindableInt = new BindableInt();
      
      public const text:BindableString = new BindableString(null);
      
      public const highlight:BindableBoolean = new BindableBoolean(false);
      
      private var _iconResource:FullResourcePattern;
      
      private var _action:IMapEntityAction;
      
      public function ClickIconTrait(param1:FullResourcePattern, param2:int, param3:int = 0, param4:BindablePointLite = null)
      {
         super(param2,param3,0,-87,param4);
         this._iconResource = param1;
         _lockTrigger = false;
         enabled.changed.add(this.handleEnabledChanged);
         enabled.value = false;
      }
      
      public function get iconResource() : FullResourcePattern
      {
         return this._iconResource;
      }
      
      public function set action(param1:IMapEntityAction) : void
      {
         this._action = param1;
      }
      
      override public function mouseClick() : void
      {
         if(enabled.value)
         {
            if(this._action)
            {
               this._action.execute(owner);
            }
         }
         super.mouseClick();
      }
      
      public function handleActionAvailableCommand(param1:Boolean, param2:String = null) : void
      {
         this.enabled.value = param1;
         this.toolTip = param2;
      }
      
      private function handleEnabledChanged() : void
      {
         clickPriority = enabled.value ? HIGH_CLICK_PRIO : LOW_CLICK_PRIO;
         if(enabled.value)
         {
            AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_ICON_APPEARS_SOUND);
         }
      }
   }
}

