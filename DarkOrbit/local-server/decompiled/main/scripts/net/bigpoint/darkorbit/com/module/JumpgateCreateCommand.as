package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class JumpgateCreateCommand implements IModule
   {
      
      private static var _instance:JumpgateCreateCommand;
      
      public var gateId:int = 0;
      
      public var factionId:int = 0;
      
      public var designId:int = 0;
      
      public var x:int = 0;
      
      public var y:int = 0;
      
      public var isVisibleOnMinimap:Boolean = false;
      
      public var showBubble:Boolean = false;
      
      public var decoratorAssetTypes:Vector.<int>;
      
      public function JumpgateCreateCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0, param6:Boolean = false, param7:Boolean = false, param8:Vector.<int> = null)
      {
         super();
         this.gateId = param1;
         this.factionId = param2;
         this.designId = param3;
         this.x = param4;
         this.y = param5;
         this.isVisibleOnMinimap = param6;
         this.showBubble = param7;
         if(param8 == null)
         {
            this.decoratorAssetTypes = new Vector.<int>();
         }
         else
         {
            this.decoratorAssetTypes = param8;
         }
      }
      
      public static function get instance() : JumpgateCreateCommand
      {
         return _instance || (_instance = new JumpgateCreateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 3389;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 26;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         this.gateId = param1.readInt();
         this.gateId = this.gateId >>> 10 % 32 | this.gateId << 32 - 10 % 32;
         this.factionId = param1.readInt();
         this.factionId = this.factionId << 2 % 32 | this.factionId >>> 32 - 2 % 32;
         this.designId = param1.readInt();
         this.designId = this.designId << 15 % 32 | this.designId >>> 32 - 15 % 32;
         this.x = param1.readInt();
         this.x = this.x >>> 11 % 32 | this.x << 32 - 11 % 32;
         this.y = param1.readInt();
         this.y = this.y >>> 9 % 32 | this.y << 32 - 9 % 32;
         this.isVisibleOnMinimap = param1.readBoolean();
         this.showBubble = param1.readBoolean();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.decoratorAssetTypes.length > 0)
         {
            this.decoratorAssetTypes.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ << 2 % 32 | _loc4_ >>> 32 - 2 % 32;
            this.decoratorAssetTypes.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:int = 0;
         param1.writeShort(3389);
         param1.writeInt(this.gateId << 10 % 32 | this.gateId >>> 32 - 10 % 32);
         param1.writeInt(this.factionId >>> 2 % 32 | this.factionId << 32 - 2 % 32);
         param1.writeInt(this.designId >>> 15 % 32 | this.designId << 32 - 15 % 32);
         param1.writeInt(this.x << 11 % 32 | this.x >>> 32 - 11 % 32);
         param1.writeInt(this.y << 9 % 32 | this.y >>> 32 - 9 % 32);
         param1.writeBoolean(this.isVisibleOnMinimap);
         param1.writeBoolean(this.showBubble);
         param1.writeByte(this.decoratorAssetTypes.length);
         for each(_loc2_ in this.decoratorAssetTypes)
         {
            param1.writeInt(_loc2_ >>> 2 % 32 | _loc2_ << 32 - 2 % 32);
         }
      }
   }
}

