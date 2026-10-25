package net.bigpoint.darkorbit.map.common.tools
{
   import com.bigpoint.utils.bindables.BindableString;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   
   public class DebugInfoTrait extends EntityTraitBase
   {
      
      public const info1:BindableString = new BindableString();
      
      public const info2:BindableString = new BindableString();
      
      public function DebugInfoTrait(param1:String)
      {
         super();
         this.info1.value = param1;
      }
   }
}

