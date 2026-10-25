package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AbilityEffectDeActivationCommand implements IModule
   {
      
      private static var _instance:AbilityEffectDeActivationCommand;
      
      public var selectedAbilityId:int = 0;
      
      public var activatorId:int = 0;
      
      public var targetIds:Vector.<int>;
      
      public function AbilityEffectDeActivationCommand(param1:int = 0, param2:int = 0, param3:Vector.<int> = null)
      {
         super();
         this.selectedAbilityId = param1;
         this.activatorId = param2;
         if(param3 == null)
         {
            this.targetIds = new Vector.<int>();
         }
         else
         {
            this.targetIds = param3;
         }
      }
      
      public static function get instance() : AbilityEffectDeActivationCommand
      {
         return _instance || (_instance = new AbilityEffectDeActivationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 282;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         this.selectedAbilityId = param1.readInt();
         this.selectedAbilityId = this.selectedAbilityId << 7 % 32 | this.selectedAbilityId >>> 32 - 7 % 32;
         this.activatorId = param1.readInt();
         this.activatorId = this.activatorId >>> 15 % 32 | this.activatorId << 32 - 15 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.targetIds.length > 0)
         {
            this.targetIds.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ << 3 % 32 | _loc4_ >>> 32 - 3 % 32;
            this.targetIds.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:int = 0;
         param1.writeShort(282);
         param1.writeInt(this.selectedAbilityId >>> 7 % 32 | this.selectedAbilityId << 32 - 7 % 32);
         param1.writeInt(this.activatorId << 15 % 32 | this.activatorId >>> 32 - 15 % 32);
         param1.writeByte(this.targetIds.length);
         for each(_loc2_ in this.targetIds)
         {
            param1.writeInt(_loc2_ >>> 3 % 32 | _loc2_ << 32 - 3 % 32);
         }
      }
   }
}

