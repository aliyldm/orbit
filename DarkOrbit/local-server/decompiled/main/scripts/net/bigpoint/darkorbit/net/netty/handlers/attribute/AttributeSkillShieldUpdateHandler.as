package net.bigpoint.darkorbit.net.netty.handlers.attribute
{
   import net.bigpoint.darkorbit.com.module.AttributeSkillShieldUpdateCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class AttributeSkillShieldUpdateHandler extends BaseHandler
   {
      
      public function AttributeSkillShieldUpdateHandler()
      {
         super();
      }
      
      public static function run(param1:AttributeSkillShieldUpdateCommand) : void
      {
         var _loc2_:Boolean = Boolean(param1.shieldSkillId);
         var _loc3_:int = param1.minSkinShieldTwinkle;
         var _loc4_:int = param1.maxSkinShieldTwinkle;
         _main.getConnectionManager().getAttributeAssembly().assembleShieldSkillUpdate(_loc2_,_loc3_,_loc4_);
      }
   }
}

