package net.bigpoint.darkorbit.com.module.porting.synthesis
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class SynthesisGroupCommand implements IModule
   {
      
      private static var _instance:SynthesisGroupCommand;
      
      public var button:String = "";
      
      public var moduleList:Vector.<SynthesisModuleListCommand>;
      
      public var group:String = "";
      
      public function SynthesisGroupCommand(param1:String = "", param2:String = "", param3:Vector.<SynthesisModuleListCommand> = null)
      {
         super();
         this.button = param2;
         if(param3 == null)
         {
            this.moduleList = new Vector.<SynthesisModuleListCommand>();
         }
         else
         {
            this.moduleList = param3;
         }
         this.group = param1;
      }
      
      public static function get instance() : SynthesisGroupCommand
      {
         return _instance || (_instance = new SynthesisGroupCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -12408;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:SynthesisModuleListCommand = null;
         this.button = param1.readUTF();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.moduleList.length > 0)
         {
            this.moduleList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readShort();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = SynthesisModuleListCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.moduleList.push(_loc4_);
            _loc2_++;
         }
         this.group = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:SynthesisModuleListCommand = null;
         param1.writeShort(-12408);
         param1.writeUTF(this.button);
         param1.writeShort(this.moduleList.length);
         for each(_loc2_ in this.moduleList)
         {
            _loc2_.write(param1);
         }
         param1.writeUTF(this.group);
      }
   }
}

