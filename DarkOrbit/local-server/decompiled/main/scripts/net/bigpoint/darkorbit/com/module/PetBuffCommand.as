package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetBuffCommand implements IModule
   {
      
      private static var _instance:PetBuffCommand;
      
      public static const ACTION_ADD:int = 0;
      
      public static const ACTION_REMOVE:int = 1;
      
      public static const ACTION__MAX:int = 2;
      
      public var effectAction:int = 0;
      
      public var effectId:int = 0;
      
      public var addingParameters:Vector.<int>;
      
      public function PetBuffCommand(param1:int = 0, param2:int = 0, param3:Vector.<int> = null)
      {
         super();
         this.effectAction = param1;
         this.effectId = param2;
         if(param3 == null)
         {
            this.addingParameters = new Vector.<int>();
         }
         else
         {
            this.addingParameters = param3;
         }
      }
      
      public static function get instance() : PetBuffCommand
      {
         return _instance || (_instance = new PetBuffCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 239;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         this.effectAction = param1.readShort();
         this.effectId = param1.readShort();
         this.effectId = 0xFFFF & ((0xFFFF & this.effectId) << 13 % 16 | (0xFFFF & this.effectId) >>> 16 - 13 % 16);
         this.effectId = this.effectId > 32767 ? int(this.effectId - 65536) : this.effectId;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.addingParameters.length > 0)
         {
            this.addingParameters.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ << 4 % 32 | _loc4_ >>> 32 - 4 % 32;
            this.addingParameters.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:int = 0;
         param1.writeShort(239);
         param1.writeShort(this.effectAction);
         param1.writeShort(0xFFFF & ((0xFFFF & this.effectId) >>> 13 % 16 | (0xFFFF & this.effectId) << 16 - 13 % 16));
         param1.writeByte(this.addingParameters.length);
         for each(_loc2_ in this.addingParameters)
         {
            param1.writeInt(_loc2_ >>> 4 % 32 | _loc2_ << 32 - 4 % 32);
         }
      }
   }
}

