package net.bigpoint.darkorbit.map.model.effects.impl
{
   import com.bigpoint.utils.bindables.BindableString;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   
   public class AlertEffect extends Effect
   {
      
      public static const ID:int = EffectIDList.ALERT_EFFECT;
      
      public const text:BindableString = new BindableString();
      
      public function AlertEffect(param1:String = null)
      {
         super(ID,PERSISTANT,null);
         this.text.value = param1;
      }
      
      override public function reactivate(param1:Effect) : void
      {
         this.text.value = (param1 as AlertEffect).text.value;
      }
   }
}

