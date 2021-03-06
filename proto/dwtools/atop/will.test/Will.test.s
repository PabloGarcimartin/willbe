( function _Will_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../Tools.s' );

  _.include( 'wTesting' );;
  _.include( 'wExternalFundamentals' );
  _.include( 'wFiles' );

}

var _global = _global_;
var _ = _global_.wTools;

//

function onSuiteBegin()
{
  let self = this;
  // debugger;
  self.tempDir = _.path.dirTempOpen( _.path.join( __dirname, '../..'  ), 'Will' );
  self.staticDirPath = _.path.join( __dirname, 'modules' );
  // debugger;
}

function onSuiteEnd()
{
  let self = this;
  debugger;
  _.assert( _.strHas( self.tempDir, '/dwtools/tmp.tmp' ) )
  _.fileProvider.filesDelete( self.tempDir );
}

/*

  .help - Get help.
  .list - List information about the current module.
  .paths.list - List paths of the current module.
  .submodules.list - List submodules of the current module.
  .reflectors.list - List avaialable reflectors.
  .steps.list - List avaialable steps.
  .builds.list - List avaialable builds.
  .exports.list - List avaialable exports.
  .about.list - List descriptive information about the module.
  .execution.list - List execution scenarios.
  .submodules.download - Download each submodule if such was not downloaded so far.
  .submodules.upgrade - Upgrade each submodule, checking for available updates for such.
  .submodules.clean - Delete all downloaded submodules.
  .clean - Clean current module. Delete genrated artifacts, temp files and downloaded submodules.
  .clean.what - Find out which files will be deleted by clean command.
  .build - Build current module with spesified criterion.
  .export - Export selected the module with spesified criterion. Save output to output file and archive.
  .with - Use "with" to select a module.
  .each - Use "each" to iterate each module in a directory.

*/

//

function singleModuleSimplest( test )
{
  let self = this;

  let singleModuleSrc = _.path.join( self.staticDirPath, 'single' );
  let singleModuleDst = _.path.join( self.tempDir, test.name );

  _.fileProvider.filesReflect({ reflectMap : { [ singleModuleSrc ] : singleModuleDst }  })

  let willExecPath = _.path.join( _.path.normalize( __dirname ), '../will/Exec2' );
  willExecPath = _.path.nativize( willExecPath );

  let shell = _.sheller
  ({
    path : 'node ' + willExecPath,
    currentPath : singleModuleDst,
    outputCollecting : 1
  })

  let con = new _.Consequence().take( null )

  .keep( () =>
  {
    test.case = 'simple run without args'
    return shell()
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( got.output.length );
      return null;
    })
  })

  return con;
}

singleModuleSimplest.timeOut = 60000;

//

function singleModuleList( test )
{
  let self = this;

  let singleModuleSrc = _.path.join( self.staticDirPath, 'single' );
  let singleModuleDst = _.path.join( self.tempDir, test.name );

  _.fileProvider.filesReflect({ reflectMap : { [ singleModuleSrc ] : singleModuleDst }  })

  let willExecPath = _.path.join( _.path.normalize( __dirname ), '../will/Exec2' );
  willExecPath = _.path.nativize( willExecPath );

  let shell = _.sheller
  ({
    path : 'node ' + willExecPath,
    currentPath : singleModuleDst,
    outputCollecting : 1
  })

  let con = new _.Consequence().take( null )

  /* - */

  .keep( () =>
  {
    test.case = 'list'
    return shell({ args : [ '.list' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, `name : 'single'` ) );
      test.is( _.strHas( got.output, `description : 'Module for testing'` ) );
      test.is( _.strHas( got.output, `version : '0.0.1'` ) );
      return null;
    })
  })

  /* - */

  .keep( () =>
  {
    test.case = 'module info'
    return shell({ args : [ '.paths.list' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, `proto : './proto'` ) );
      test.is( _.strHas( got.output, `in : '.'` ) );
      test.is( _.strHas( got.output, `out : 'out'` ) );
      test.is( _.strHas( got.output, `out.debug : './out.debug'` ) );
      test.is( _.strHas( got.output, `out.release : './out.release'` ) );
      return null;
    })
  })



  .keep( () =>
  {
    test.case = 'submodules list'
    return shell({ args : [ '.submodules.list' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( got.output.length );
      return null;
    })
  })

  /* - */

  .keep( () =>
  {
    test.case = 'reflectors.list'
    return shell({ args : [ '.reflectors.list' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'reflector::reflect.proto.0' ))
      test.is( _.strHas( got.output, `./proto : './out.release'` ))
      test.is( _.strHas( got.output, `reflector::reflect.proto.1` ))
      test.is( _.strHas( got.output, ` ./proto : './out.debug'` ))
      return null;
    })
  })

  /* - */

  .keep( () =>
  {
    test.case = 'steps.list'
    return shell({ args : [ '.steps.list' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'step::reflect.proto.0' ))
      test.is( _.strHas( got.output, 'step::reflect.proto.1' ))
      test.is( _.strHas( got.output, 'step::reflect.proto.2' ))
      test.is( _.strHas( got.output, 'step::reflect.proto.3' ))
      test.is( _.strHas( got.output, 'step::export.proto' ))

      return null;
    })
  })

  /* - */

  .keep( () =>
  {
    test.case = '.builds.list'
    return shell({ args : [ '.builds.list' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'build::debug.raw' ));
      test.is( _.strHas( got.output, 'build::debug.compiled' ));
      test.is( _.strHas( got.output, 'build::release.raw' ));
      test.is( _.strHas( got.output, 'build::release.compiled' ));
      test.is( _.strHas( got.output, 'build::all' ));

      return null;
    })
  })

  /* - */

  .keep( () =>
  {
    test.case = '.exports.list'
    return shell({ args : [ '.exports.list' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'build::proto.export' ));
      test.is( _.strHas( got.output, 'steps : ' ));
      test.is( _.strHas( got.output, 'build::debug.raw' ));
      test.is( _.strHas( got.output, 'step::export.proto' ));

      return null;
    })
  })

  /* - */

  .keep( () =>
  {
    test.case = '.about.list'
    return shell({ args : [ '.about.list' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );

      test.is( _.strHas( got.output, `name : 'single'` ));
      test.is( _.strHas( got.output, `description : 'Module for testing'` ));
      test.is( _.strHas( got.output, `version : '0.0.1'` ));
      test.is( _.strHas( got.output, `enabled : 1` ));
      test.is( _.strHas( got.output, `interpreters :` ));
      test.is( _.strHas( got.output, `'nodejs >= 6.0.0'` ));
      test.is( _.strHas( got.output, `'chrome >= 60.0.0'` ));
      test.is( _.strHas( got.output, `'firefox >= 60.0.0'` ));
      test.is( _.strHas( got.output, `'nodejs >= 6.0.0'` ));
      test.is( _.strHas( got.output, `keywords :` ));
      test.is( _.strHas( got.output, `'wTools'` ));

      return null;
    })
  })

  /* - */

  .keep( () =>
  {
    test.case = '.execution.list'
    return shell({ args : [ '.execution.list' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( got.output.length );
      return null;
    })
  })

  return con;
}

singleModuleList.timeOut = 60000;

//

function singleModuleSubmodules( test )
{
  let self = this;

  let singleModuleSrc = _.path.join( self.staticDirPath, 'single' );
  let singleModuleDst = _.path.join( self.tempDir, test.name );

  _.fileProvider.filesReflect({ reflectMap : { [ singleModuleSrc ] : singleModuleDst }  })

  let willExecPath = _.path.join( _.path.normalize( __dirname ), '../will/Exec2' );
  willExecPath = _.path.nativize( willExecPath );

  let shell = _.sheller
  ({
    path : 'node ' + willExecPath,
    currentPath : singleModuleDst,
    outputCollecting : 1
  })

  let con = new _.Consequence().take( null )

  /* - */

  .keep( () =>
  {
    test.case = '.submodules.download'
    return shell({ args : [ '.submodules.download' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, '0/0 submodule(s) of module::single were downloaded in' ) );
      return null;
    })
  })

  /* - */

  .keep( () =>
  {
    test.case = '.submodules.download'
    return shell({ args : [ '.submodules.download' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, '0/0 submodule(s) of module::single were downloaded in' ) );
      test.is( !_.fileProvider.fileExists( _.path.join( singleModuleDst, '.module' ) ) )
      test.is( !_.fileProvider.fileExists( _.path.join( singleModuleDst, 'modules' ) ) )
      return null;
    })
  })

  /* - */

  .keep( () =>
  {
    test.case = '.submodules.upgrade'
    return shell({ args : [ '.submodules.upgrade' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, '0/0 submodule(s) of module::single were upgraded in' ) );
      test.is( !_.fileProvider.fileExists( _.path.join( singleModuleDst, '.module' ) ) )
      test.is( !_.fileProvider.fileExists( _.path.join( singleModuleDst, 'modules' ) ) )
      return null;
    })
  })

  /* - */

  .keep( () =>
  {
    test.case = '.submodules.clean'
    return shell({ args : [ '.submodules.clean' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'Clean deleted 0 file(s) in' ) );
      test.is( !_.fileProvider.fileExists( _.path.join( singleModuleDst, '.module' ) ) )
      test.is( !_.fileProvider.fileExists( _.path.join( singleModuleDst, 'modules' ) ) )
      return null;
    })
  })

  return con;

}

singleModuleSubmodules.timeOut = 60000;

//

function singleModuleClean( test )
{
  let self = this;

  let singleModuleSrc = _.path.join( self.staticDirPath, 'single' );
  let singleModuleDst = _.path.join( self.tempDir, test.name );

  _.fileProvider.filesReflect({ reflectMap : { [ singleModuleSrc ] : singleModuleDst }  })

  let willExecPath = _.path.join( _.path.normalize( __dirname ), '../will/Exec2' );
  willExecPath = _.path.nativize( willExecPath );

  let shell = _.sheller
  ({
    path : 'node ' + willExecPath,
    currentPath : singleModuleDst,
    outputCollecting : 1
  })

  let con = new _.Consequence().take( null )

  /* - */

  .keep( () =>
  {
    test.case = '.clean '
    return _.shell
    ({
      path : 'node ' + willExecPath,
      currentPath : singleModuleDst,
      outputCollecting : 1,
      args : [ '.build' ]
    })
    .ifNoErrorThen( () =>
    {
      return shell({ args : [ '.clean' ] })
      .ifNoErrorThen( ( got ) =>
      {
        test.identical( got.exitCode, 0 );
        test.is( _.strHas( got.output, 'Clean deleted 0 file(s) in' ) );
        test.is( !_.fileProvider.fileExists( _.path.join( singleModuleDst, '.module' ) ) )
        test.is( !_.fileProvider.fileExists( _.path.join( singleModuleDst, 'modules' ) ) )
        return null;
      })
    })
  })

  /* - */

  .keep( () =>
  {
    test.case = '.clean.what '
    return _.shell
    ({
      path : 'node ' + willExecPath,
      currentPath : singleModuleDst,
      outputCollecting : 1,
      args : [ '.build' ]
    })
    .ifNoErrorThen( () =>
    {
      return shell({ args : [ '.clean.what' ] })
      .ifNoErrorThen( ( got ) =>
      {
        test.identical( got.exitCode, 0 );
        test.is( _.strHas( got.output, 'Clean will delete 0 file(s)' ) );
        return null;
      })
    })
  })

  return con;

}

singleModuleClean.timeOut = 60000;

//

function singleModuleBuild( test )
{
  let self = this;

  let singleModuleSrc = _.path.join( self.staticDirPath, 'single' );
  let singleModuleDst = _.path.join( self.tempDir, test.name );

  _.fileProvider.filesReflect({ reflectMap : { [ singleModuleSrc ] : singleModuleDst }  })

  let willExecPath = _.path.join( _.path.normalize( __dirname ), '../will/Exec2' );
  willExecPath = _.path.nativize( willExecPath );

  let shell = _.sheller
  ({
    path : 'node ' + willExecPath,
    currentPath : singleModuleDst,
    outputCollecting : 1
  })

  let con = new _.Consequence().take( null )

  .keep( () =>
  {
    test.case = '.build'
    let buildOutPath = _.path.join( singleModuleDst, 'out.debug' );
    _.fileProvider.filesDelete( buildOutPath );
    return shell({ args : [ '.build' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'Building debug.raw' ) );
      test.is( _.strHas( got.output, 'Reflect 2 files to' ) );
      test.is( _.strHas( got.output, 'Built debug.raw in' ) );

      var files = _.fileProvider.filesFind({ filePath : buildOutPath, recursive : '2', outputFormat : 'relative' })
      test.identical( files, [ './Single.s' ] );

      return null;
    })
  })

  .keep( () =>
  {
    test.case = '.build debug.raw'
    let buildOutPath = _.path.join( singleModuleDst, 'out.debug' );
    _.fileProvider.filesDelete( buildOutPath );
    return shell({ args : [ '.build debug.raw' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'Building debug.raw' ) );
      test.is( _.strHas( got.output, 'Reflect 2 files to' ) );
      test.is( _.strHas( got.output, 'Built debug.raw in' ) );

      var files = _.fileProvider.filesFind({ filePath : buildOutPath, recursive : '2', outputFormat : 'relative' })
      test.identical( files, [ './Single.s' ] );

      return null;
    })
  })

  /* - */

  .keep( () =>
  {
    test.case = '.build release.raw'
    let buildOutPath = _.path.join( singleModuleDst, 'out.release' );
    _.fileProvider.filesDelete( buildOutPath );
    return shell({ args : [ '.build release.raw' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'Building release.raw' ) );
      test.is( _.strHas( got.output, 'Reflect 2 files to' ) );
      test.is( _.strHas( got.output, 'Built release.raw in' ) );

      var files = _.fileProvider.filesFind({ filePath : buildOutPath, recursive : '2', outputFormat : 'relative' })
      test.identical( files, [ './Single.s' ] );

      return null;
    })
  })

  /* - */

  .keep( () =>
  {
    test.case = '.build wrong'
    let buildOutDebugPath = _.path.join( singleModuleDst, 'out.debug' );
    let buildOutReleasePath = _.path.join( singleModuleDst, 'out.release' );
    _.fileProvider.filesDelete( buildOutDebugPath );
    _.fileProvider.filesDelete( buildOutReleasePath );
    var o =
    {
      path : 'node ' + willExecPath,
      currentPath : singleModuleDst,
      outputCollecting : 1,
      args : [ '.build wrong' ]
    }
    return test.shouldThrowError( _.shell( o ) )
    .keep( ( got ) =>
    {
      test.is( o.exitCode !== 0 );
      test.is( o.output.length );
      test.is( !_.fileProvider.fileExists( buildOutDebugPath ) )
      test.is( !_.fileProvider.fileExists( buildOutReleasePath ) )

      return null;
    })
  })

  return con;
}

singleModuleBuild.timeOut = 60000;

//

function singleModuleExport( test )
{
  let self = this;

  let singleModuleSrc = _.path.join( self.staticDirPath, 'single' );
  let singleModuleDst = _.path.join( self.tempDir, test.name );

  _.fileProvider.filesReflect({ reflectMap : { [ singleModuleSrc ] : singleModuleDst }  })

  let willExecPath = _.path.join( _.path.normalize( __dirname ), '../will/Exec2' );
  willExecPath = _.path.nativize( willExecPath );

  let shell = _.sheller
  ({
    path : 'node ' + willExecPath,
    currentPath : singleModuleDst,
    outputCollecting : 1
  })

  let buildOutPath = _.path.join( singleModuleDst, 'out.debug' );
  _.fileProvider.filesDelete( buildOutPath );

  let con = new _.Consequence().take( null )

  /* - */

  .thenKeep( () =>
  {
    test.case = '.export'
    let buildOutPath = _.path.join( singleModuleDst, 'out.debug' );
    let exportPath = _.path.join( singleModuleDst, 'out' );
    _.fileProvider.filesDelete( buildOutPath );
    _.fileProvider.filesDelete( exportPath );
    return shell({ args : [ '.export' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, '+ Reflect 2 files' ) );
      test.is( _.strHas( got.output, '+ Write out file to' ) );
      test.is( _.strHas( got.output, 'Exported proto.export with 2 files in' ) );

      var files = _.fileProvider.filesFind({ filePath : buildOutPath, recursive : '2', outputFormat : 'relative' })
      test.identical( files, [ './Single.s' ] );
      var files = _.fileProvider.filesFind({ filePath : exportPath, recursive : '2', outputFormat : 'relative' })
      test.identical( files, [ './single.out.will.yml' ] );

      return null;
    })
  })

  /* - */

  .thenKeep( () =>
  {
    test.case = '.export.proto'
    let buildOutPath = _.path.join( singleModuleDst, 'out.debug' );
    let exportPath = _.path.join( singleModuleDst, 'out' );
    _.fileProvider.filesDelete( buildOutPath );
    _.fileProvider.filesDelete( exportPath );
    return shell({ args : [ '.export proto.export' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'Exporting proto.export' ) );
      test.is( _.strHas( got.output, 'Reflect 2 files to' ) );
      test.is( _.strHas( got.output, 'Exported proto.export with 2 files' ) );

      var files = _.fileProvider.filesFind({ filePath : buildOutPath, recursive : '2', outputFormat : 'relative' })
      test.identical( files, [ './Single.s' ] );
      var files = _.fileProvider.filesFind({ filePath : exportPath, recursive : '2', outputFormat : 'relative' })
      test.identical( files, [ './single.out.will.yml' ] );

      return null;
    })
  })


  return con;
}

singleModuleExport.timeOut = 60000;

//

function withSubmodulesSimplest( test )
{
  let self = this;

  let singleModuleSrc = _.path.join( self.staticDirPath, 'submodules' );
  let singleModuleDst = _.path.join( self.tempDir, test.name );
  let modulesPath = _.path.join( singleModuleDst, '.module' );

  _.fileProvider.filesReflect({ reflectMap : { [ singleModuleSrc ] : singleModuleDst }  })

  let willExecPath = _.path.join( _.path.normalize( __dirname ), '../will/Exec2' );
  willExecPath = _.path.nativize( willExecPath );

  let shell = _.sheller
  ({
    path : 'node ' + willExecPath,
    currentPath : singleModuleDst,
    outputCollecting : 1
  })

  let con = new _.Consequence().take( null )

  .keep( () =>
  {
    test.case = 'module info'
    return shell({ args : [ '.list' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, `name : 'withSubmodules'` ) );
      test.is( _.strHas( got.output, `description : 'Module for testing'` ) );
      test.is( _.strHas( got.output, `version : '0.0.1'` ) );
      return null;
    })
  })

  return con;
}

withSubmodulesSimplest.timeOut = 200000;

//

function withSubmodulesList( test )
{
  let self = this;

  let singleModuleSrc = _.path.join( self.staticDirPath, 'submodules' );
  let singleModuleDst = _.path.join( self.tempDir, test.name );
  let modulesPath = _.path.join( singleModuleDst, '.module' );

  _.fileProvider.filesReflect({ reflectMap : { [ singleModuleSrc ] : singleModuleDst }  })

  let willExecPath = _.path.join( _.path.normalize( __dirname ), '../will/Exec2' );
  willExecPath = _.path.nativize( willExecPath );

  let shell = _.sheller
  ({
    path : 'node ' + willExecPath,
    currentPath : singleModuleDst,
    outputCollecting : 1
  })

  let con = new _.Consequence().take( null )

  /* - */

  .keep( () =>
  {
    test.case = 'submodules list'
    return shell({ args : [ '.submodules.list' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'submodule::Tools' ) );
      test.is( _.strHas( got.output, 'submodule::PathFundamentals' ) );
      return null;
    })
  })

  /* - */

  .keep( () =>
  {
    test.case = 'reflectors.list'
    return shell({ args : [ '.reflectors.list' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'reflector::reflect.proto.0' ))
      test.is( _.strHas( got.output, `reflector::reflect.proto.1` ))
      return null;
    })
  })

  /* - */

  .keep( () =>
  {
    test.case = 'steps.list'
    return shell({ args : [ '.steps.list' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'step::reflect.proto.0' ))
      test.is( _.strHas( got.output, 'step::reflect.proto.1' ))
      test.is( _.strHas( got.output, 'step::reflect.proto.2' ))
      test.is( _.strHas( got.output, 'step::reflect.proto.3' ))
      test.is( _.strHas( got.output, 'step::export.proto' ))

      return null;
    })
  })

  /* - */

  .keep( () =>
  {
    test.case = '.builds.list'
    return shell({ args : [ '.builds.list' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'build::debug.raw' ));
      test.is( _.strHas( got.output, 'build::debug.compiled' ));
      test.is( _.strHas( got.output, 'build::release.raw' ));
      test.is( _.strHas( got.output, 'build::release.compiled' ));
      test.is( _.strHas( got.output, 'build::all' ));

      return null;
    })
  })

  /* - */

  .keep( () =>
  {
    test.case = '.exports.list'
    return shell({ args : [ '.exports.list' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'build::proto.export' ));
      test.is( _.strHas( got.output, 'steps : ' ));
      test.is( _.strHas( got.output, 'build::debug.raw' ));
      test.is( _.strHas( got.output, 'step::export.proto' ));

      return null;
    })
  })

  /* - */

  .keep( () =>
  {
    test.case = '.about.list'
    return shell({ args : [ '.about.list' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );

      test.is( _.strHas( got.output, `name : 'withSubmodules'` ));
      test.is( _.strHas( got.output, `description : 'Module for testing'` ));
      test.is( _.strHas( got.output, `version : '0.0.1'` ));
      test.is( _.strHas( got.output, `enabled : 1` ));
      test.is( _.strHas( got.output, `interpreters :` ));
      test.is( _.strHas( got.output, `'nodejs >= 6.0.0'` ));
      test.is( _.strHas( got.output, `'chrome >= 60.0.0'` ));
      test.is( _.strHas( got.output, `'firefox >= 60.0.0'` ));
      test.is( _.strHas( got.output, `'nodejs >= 6.0.0'` ));
      test.is( _.strHas( got.output, `keywords :` ));
      test.is( _.strHas( got.output, `'wTools'` ));

      return null;
    })
  })

  /* - */

  .keep( () =>
  {
    test.case = '.execution.list'
    return shell({ args : [ '.execution.list' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( got.output.length );
      return null;
    })
  })

  return con;
}

withSubmodulesList.timeOut = 60000;

//

function withSubmodulesSubmodules( test )
{
  let self = this;

  let singleModuleSrc = _.path.join( self.staticDirPath, 'submodules' );
  let singleModuleDst = _.path.join( self.tempDir, test.name );
  let modulesPath = _.path.join( singleModuleDst, '.module' );

  _.fileProvider.filesReflect({ reflectMap : { [ singleModuleSrc ] : singleModuleDst }  })

  let willExecPath = _.path.join( _.path.normalize( __dirname ), '../will/Exec2' );
  willExecPath = _.path.nativize( willExecPath );

  let shell = _.sheller
  ({
    path : 'node ' + willExecPath,
    currentPath : singleModuleDst,
    outputCollecting : 1
  })

  /* */

  let con = new _.Consequence().take( null )

  /* */

  .keep( () =>
  {
    test.case = '.submodules.download';
    _.fileProvider.filesDelete( modulesPath );
    return shell({ args : [ '.submodules.download' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, '2/2 submodule(s) of module::withSubmodules were downloaded in' ) );

      var files = _.fileProvider.filesFind({ filePath : modulesPath, recursive : '2', outputFormat : 'relative' })
      test.is( files.length );

      test.is( _.fileProvider.fileExists( _.path.join( modulesPath, 'Tools' ) ) )
      test.is( _.fileProvider.fileExists( _.path.join( modulesPath, 'PathFundamentals' ) ) )
      return null;
    })
  })

  /* */

  .keep( () =>  shell({ args : [ '.submodules.upgrade' ] }) )
  .keep( () =>
  {
    test.case = '.submodules.upgrade'

    return shell({ args : [ '.submodules.upgrade' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, '2/2 submodule(s) of module::withSubmodules were upgraded in' ) );
      test.is( _.fileProvider.fileExists( _.path.join( modulesPath, 'Tools' ) ) )
      test.is( _.fileProvider.fileExists( _.path.join( modulesPath, 'PathFundamentals' ) ) )
      test.is( !_.fileProvider.fileExists( _.path.join( singleModuleDst, 'modules' ) ) )

      var files = _.fileProvider.filesFind({ filePath : _.path.join( modulesPath, 'Tools' ), recursive : '2', outputFormat : 'relative' })
      test.is( files.length );

      var files = _.fileProvider.filesFind({ filePath : _.path.join( modulesPath, 'PathFundamentals' ), recursive : '2', outputFormat : 'relative' })
      test.is( files.length );

      return null;
    })
  })

  /* */

  .keep( () =>
  {
    test.case = '.submodules.clean';

    let files = _.fileProvider.filesFind
    ({
      filePath : modulesPath,
      recursive : '2',
      includingDirs : 1,
      includingTerminals : 1,
      includingTransient : 1
    });

    return shell({ args : [ '.submodules.clean' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, `${files.length}` ) );
      test.is( !_.fileProvider.fileExists( _.path.join( singleModuleDst, '.module' ) ) )
      test.is( !_.fileProvider.fileExists( _.path.join( singleModuleDst, 'modules' ) ) )
      return null;
    })
  })

  /* */

  return con;
}

withSubmodulesSubmodules.timeOut = 60000;

//

function withSubmodulesClean( test )
{
  let self = this;

  let singleModuleSrc = _.path.join( self.staticDirPath, 'submodules' );
  let singleModuleDst = _.path.join( self.tempDir, test.name );
  let modulesPath = _.path.join( singleModuleDst, '.module' );

  _.fileProvider.filesReflect({ reflectMap : { [ singleModuleSrc ] : singleModuleDst }  })

  let willExecPath = _.path.join( _.path.normalize( __dirname ), '../will/Exec2' );
  willExecPath = _.path.nativize( willExecPath );

  let shell = _.sheller
  ({
    path : 'node ' + willExecPath,
    currentPath : singleModuleDst,
    outputCollecting : 1
  })

  let con = new _.Consequence().take( null )

  .keep( () =>  shell({ args : [ '.submodules.upgrade' ] }) )

  /* - */

  .keep( () =>
  {
    test.case = '.clean ';

    let files = _.fileProvider.filesFind
    ({
      filePath : modulesPath,
      recursive : '2',
      includingTerminals : 1,
      includingDirs : 1,
      includingTransient : 1
    })

    return _.shell
    ({
      path : 'node ' + willExecPath,
      currentPath : singleModuleDst,
      outputCollecting : 1,
      args : [ '.build' ]
    })
    .ifNoErrorThen( () =>
    {
      test.is( files.length > 100 );
      return shell({ args : [ '.clean' ] })
    })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'Clean deleted' ) );
      test.is( !_.fileProvider.fileExists( _.path.join( singleModuleDst, '.module' ) ) )
      test.is( !_.fileProvider.fileExists( _.path.join( singleModuleDst, 'modules' ) ) )
      return null;
    })
  })

  /* - */

  .keep( () =>
  {
    test.case = '.clean.what';

    let files = _.fileProvider.filesFind
    ({
      filePath : modulesPath,
      recursive : '2',
      includingTerminals : 1,
      includingDirs : 1,
      includingTransient : 1
    })

    return _.shell
    ({
      path : 'node ' + willExecPath,
      currentPath : singleModuleDst,
      outputCollecting : 1,
      args : [ '.build' ]
    })
    .ifNoErrorThen( () =>
    {
      test.is( files.length > 100 );
      return shell({ args : [ '.clean.what' ] })
    })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, files.length ) );
      test.is( _.fileProvider.fileExists( _.path.join( singleModuleDst, '.module' ) ) )
      test.is( !_.fileProvider.fileExists( _.path.join( singleModuleDst, 'modules' ) ) )
      return null;
    })
  })

  return con;

}

withSubmodulesClean.timeOut = 35000;

//

function swithSubmodulesBuild( test )
{
  let self = this;

  let singleModuleSrc = _.path.join( self.staticDirPath, 'submodules' );
  let singleModuleDst = _.path.join( self.tempDir, test.name );
  let modulesPath = _.path.join( singleModuleDst, '.module' );

  _.fileProvider.filesReflect({ reflectMap : { [ singleModuleSrc ] : singleModuleDst }  })

  let willExecPath = _.path.join( _.path.normalize( __dirname ), '../will/Exec2' );
  willExecPath = _.path.nativize( willExecPath );

  let shell = _.sheller
  ({
    path : 'node ' + willExecPath,
    currentPath : singleModuleDst,
    outputCollecting : 1
  })

  let con = new _.Consequence().take( null )

  /* - */

  .keep( () =>
  {
    test.case = '.build withoud submodules'
    let buildOutPath = _.path.join( singleModuleDst, 'out.debug' );
    _.fileProvider.filesDelete( buildOutPath );

    return shell({ args : [ '.build' ] })
    .finally( ( err, got ) =>
    {
      test.is( !!err );
      var files = _.fileProvider.dirRead( buildOutPath )
      test.identical( files.length, 1 );

      return null;
    })
  })

  /* - */

  .keep( () =>  shell({ args : [ '.submodules.upgrade' ] }) )

  .keep( () =>
  {
    test.case = '.build'
    let buildOutPath = _.path.join( singleModuleDst, 'out.debug' );
    _.fileProvider.filesDelete( buildOutPath );

    return shell({ args : [ '.build' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );

      test.is( _.strHas( got.output, 'Building debug.raw' ) );
      test.is( _.strHas( got.output, 'Built debug.raw in' ) );

      var files = _.fileProvider.filesFind
      ({
        filePath : buildOutPath,
        recursive : '2',
        includingDirs : 1,
        includingTerminals : 1,
        includingTransient : 1,
      });

      test.is( files.length > 10 );

      return null;
    })
  })

  /* - */

  .keep( () =>
  {
    test.case = '.build wrong'
    let buildOutDebugPath = _.path.join( singleModuleDst, 'out.debug' );
    let buildOutReleasePath = _.path.join( singleModuleDst, 'out.release' );
    _.fileProvider.filesDelete( buildOutDebugPath );
    _.fileProvider.filesDelete( buildOutReleasePath );
    var o =
    {
      path : 'node ' + willExecPath,
      currentPath : singleModuleDst,
      outputCollecting : 1,
      args : [ '.build wrong' ]
    }
    return test.shouldThrowError( _.shell( o ) )
    .keep( ( got ) =>
    {
      test.is( o.exitCode !== 0 );
      test.is( o.output.length );
      test.is( !_.fileProvider.fileExists( buildOutDebugPath ) )
      test.is( !_.fileProvider.fileExists( buildOutReleasePath ) )

      return null;
    })
  })

  return con;
}

swithSubmodulesBuild.timeOut = 35000;

//

function withSubmodulesExport( test )
{
  let self = this;

  let singleModuleSrc = _.path.join( self.staticDirPath, 'submodules' );
  let singleModuleDst = _.path.join( self.tempDir, test.name );
  let modulesPath = _.path.join( singleModuleDst, '.module' );

  _.fileProvider.filesReflect({ reflectMap : { [ singleModuleSrc ] : singleModuleDst }  })

  let willExecPath = _.path.join( _.path.normalize( __dirname ), '../will/Exec2' );
  willExecPath = _.path.nativize( willExecPath );

  let shell = _.sheller
  ({
    path : 'node ' + willExecPath,
    currentPath : singleModuleDst,
    outputCollecting : 1
  })

  let con = new _.Consequence().take( null )

  /* - */

  .keep( () =>
  {
    test.case = '.export'
    let buildOutPath = _.path.join( singleModuleDst, 'out.debug' );
    let exportPath = _.path.join( singleModuleDst, 'out' );
    _.fileProvider.filesDelete( buildOutPath );
    _.fileProvider.filesDelete( exportPath );
    return shell({ args : [ '.export' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, 'Exporting proto.export' ) );

      var files = _.fileProvider.filesFind
      ({
        filePath : buildOutPath,
        recursive : '2',
        includingDirs : 1,
        includingTerminals : 1,
        includingTransient : 1,
      });
      test.is( files.length > 10 );

      var files = _.fileProvider.filesFind({ filePath : exportPath, recursive : '2', outputFormat : 'relative' })
      test.identical( files, [ './withSubmodules.out.will.yml' ] );

      return null;
    })
  })

  return con;
}

withSubmodulesExport.timeOut = 60000;

//

function submodulesDownload( test )
{
  let self = this;

  let originaDirPath = _.path.join( self.staticDirPath, 'download' );
  let dirPath = _.path.join( self.tempDir, test.name );

  debugger;
  _.fileProvider.filesReflect({ reflectMap : { [ originaDirPath ] : dirPath }  })
  _.fileProvider.filesDelete( _.pathJoin( dirPath, '.module' ) );
  _.fileProvider.filesDelete( _.pathJoin( dirPath, 'out.debug' ) );
  debugger;

  let willExecPath = _.path.nativize( _.path.join( __dirname, '../will/Exec2' ) );

  let shell = _.sheller
  ({
    path : 'node ' + willExecPath,
    currentPath : singleModuleDst,
    outputCollecting : 1,
    verbosity : 3,
  })

  let con = new _.Consequence().take( null )

  .keep( () =>
  {
    test.case = 'simple run without args'
    return shell()
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( got.output.length );
      return null;
    })
  })

  .keep( () =>
  {
    test.case = 'list'
    return shell({ args : [ '.list' ] })
    .ifNoErrorThen( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.is( _.strHas( got.output, `name : 'single'` ) );
      test.is( _.strHas( got.output, `description : 'Module for testing'` ) );
      test.is( _.strHas( got.output, `version : '0.0.1'` ) );
      return null;
    })
  })

}

//

var Self =
{

  name : 'Tools/atop/Will',
  silencing : 1,

  onSuiteBegin : onSuiteBegin,
  onSuiteEnd : onSuiteEnd,

  context :
  {
    tempDir : null,
    staticDirPath : null
  },

  tests :
  {

    singleModuleSimplest,
    singleModuleList,
    singleModuleSubmodules,
    singleModuleClean,
    singleModuleBuild,
    singleModuleExport,

    withSubmodulesSimplest,
    withSubmodulesList,
    withSubmodulesSubmodules,
    withSubmodulesClean,
    swithSubmodulesBuild,
    withSubmodulesExport,

    submodulesDownload,

  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})( );
