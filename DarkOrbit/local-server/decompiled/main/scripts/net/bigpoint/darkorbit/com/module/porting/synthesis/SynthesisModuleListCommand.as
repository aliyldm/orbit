package net.bigpoint.darkorbit.com.module.porting.synthesis
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class SynthesisModuleListCommand implements IModule
   {
      
      private static var _instance:SynthesisModuleListCommand;
      
      public var moduleListGroupType:String = "";
      
      public var modules:Vector.<SynthesisModuleCommand>;
      
      public function SynthesisModuleListCommand(param1:String = "", param2:Vector.<SynthesisModuleCommand> = null)
      {
         super();
         this.moduleListGroupType = param1;
         if(param2 == null)
         {
            this.modules = new Vector.<SynthesisModuleCommand>();
         }
         else
         {
            this.modules = param2;
         }
      }
      
      public static function get instance() : SynthesisModuleListCommand
      {
         return _instance || (_instance = new SynthesisModuleListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -22706;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:SynthesisModuleCommand = null;
         this.moduleListGroupType = param1.readUTF();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.modules.length > 0)
         {
            this.modules.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = SynthesisModuleCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.modules.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:SynthesisModuleCommand = null;
         param1.writeShort(-22706);
         param1.writeUTF(this.moduleListGroupType);
         param1.writeByte(this.modules.length);
         for each(_loc2_ in this.modules)
         {
            _loc2_.write(param1);
         }
      }
   }
}

