package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class GalaxyGateBuilderGetGatePartsCommand implements IModule
   {
      
      private static var _instance:GalaxyGateBuilderGetGatePartsCommand;
      
      public static const ERRORCODE_NONE:int = 0;
      
      public static const ERRORCODE_UNCLASSIFIED_ERROR:int = 1;
      
      public static const ERRORCODE__MAX:int = 2;
      
      public var gateId:int = 0;
      
      public var gatePartIds:Vector.<int>;
      
      public var errorCode:int = 0;
      
      public function GalaxyGateBuilderGetGatePartsCommand(param1:int = 0, param2:Vector.<int> = null, param3:int = 0)
      {
         super();
         this.gateId = param1;
         if(param2 == null)
         {
            this.gatePartIds = new Vector.<int>();
         }
         else
         {
            this.gatePartIds = param2;
         }
         this.errorCode = param3;
      }
      
      public static function get instance() : GalaxyGateBuilderGetGatePartsCommand
      {
         return _instance || (_instance = new GalaxyGateBuilderGetGatePartsCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6297;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         this.gateId = param1.readByte();
         this.gateId = 0xFF & ((0xFF & this.gateId) >>> 14 % 8 | (0xFF & this.gateId) << 8 - 14 % 8);
         this.gateId = this.gateId > 127 ? int(this.gateId - 256) : this.gateId;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.gatePartIds.length > 0)
         {
            this.gatePartIds.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readShort();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readShort();
            _loc4_ = 0xFFFF & ((0xFFFF & _loc4_) >>> 14 % 16 | (0xFFFF & _loc4_) << 16 - 14 % 16);
            _loc4_ = _loc4_ > 32767 ? int(_loc4_ - 65536) : _loc4_;
            this.gatePartIds.push(_loc4_);
            _loc2_++;
         }
         this.errorCode = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:int = 0;
         param1.writeShort(6297);
         param1.writeByte(0xFF & ((0xFF & this.gateId) << 14 % 8 | (0xFF & this.gateId) >>> 8 - 14 % 8));
         param1.writeShort(this.gatePartIds.length);
         for each(_loc2_ in this.gatePartIds)
         {
            param1.writeShort(0xFFFF & ((0xFFFF & _loc2_) << 14 % 16 | (0xFFFF & _loc2_) >>> 16 - 14 % 16));
         }
         param1.writeShort(this.errorCode);
      }
   }
}

