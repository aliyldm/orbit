package net.bigpoint.darkorbit.com.module.porting.trinitytrials
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TrinityTrialsGateEnterRequest implements IModule
   {
      
      private static var _instance:TrinityTrialsGateEnterRequest;
      
      public var attributeType:int = 0;
      
      public var difficulty:int = 0;
      
      public function TrinityTrialsGateEnterRequest(param1:int = 0, param2:int = 0)
      {
         super();
         this.attributeType = param1;
         this.difficulty = param2;
      }
      
      public static function get instance() : TrinityTrialsGateEnterRequest
      {
         return _instance || (_instance = new TrinityTrialsGateEnterRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -12375;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.attributeType = param1.readInt();
         this.attributeType = this.attributeType << 16 % 32 | this.attributeType >>> 32 - 16 % 32;
         this.difficulty = param1.readInt();
         this.difficulty = this.difficulty >>> 16 % 32 | this.difficulty << 32 - 16 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-12375);
         param1.writeInt(this.attributeType >>> 16 % 32 | this.attributeType << 32 - 16 % 32);
         param1.writeInt(this.difficulty << 16 % 32 | this.difficulty >>> 32 - 16 % 32);
      }
   }
}

