package net.bigpoint.darkorbit.com.module.porting.synthesis
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class SynthesisModuleCommand implements IModule
   {
      
      private static var _instance:SynthesisModuleCommand;
      
      public var star:int = 0;
      
      public var moduleGroupType:String = "";
      
      public var lootId:String = "";
      
      public var costs:Vector.<SynthesisCostLootCommand>;
      
      public var affectedShip:int = 0;
      
      public function SynthesisModuleCommand(param1:String = "", param2:int = 0, param3:Vector.<SynthesisCostLootCommand> = null, param4:String = "", param5:int = 0)
      {
         super();
         this.star = param5;
         this.moduleGroupType = param4;
         this.lootId = param1;
         if(param3 == null)
         {
            this.costs = new Vector.<SynthesisCostLootCommand>();
         }
         else
         {
            this.costs = param3;
         }
         this.affectedShip = param2;
      }
      
      public static function get instance() : SynthesisModuleCommand
      {
         return _instance || (_instance = new SynthesisModuleCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -22959;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:SynthesisCostLootCommand = null;
         this.star = param1.readInt();
         this.star = this.star << 15 % 32 | this.star >>> 32 - 15 % 32;
         this.moduleGroupType = param1.readUTF();
         this.lootId = param1.readUTF();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.costs.length > 0)
         {
            this.costs.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = SynthesisCostLootCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.costs.push(_loc4_);
            _loc2_++;
         }
         this.affectedShip = param1.readInt();
         this.affectedShip = this.affectedShip << 2 % 32 | this.affectedShip >>> 32 - 2 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:SynthesisCostLootCommand = null;
         param1.writeShort(-22959);
         param1.writeInt(this.star >>> 15 % 32 | this.star << 32 - 15 % 32);
         param1.writeUTF(this.moduleGroupType);
         param1.writeUTF(this.lootId);
         param1.writeByte(this.costs.length);
         for each(_loc2_ in this.costs)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.affectedShip >>> 2 % 32 | this.affectedShip << 32 - 2 % 32);
      }
   }
}

