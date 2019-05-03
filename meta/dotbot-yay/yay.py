import sys
import os
import subprocess
import dotbot
from enum import Enum

class PkgStatus(Enum):
    UP_TO_DATE = 'Up to date'
    INSTALLED = 'Installed'
    NOT_FOUND = 'Not found'
    ERROR = 'Errors occurred'
    BUILD_FAIL = 'Build failure'
    NOT_SURE = 'Could not determine'

class Yay(dotbot.Plugin):
    _directives = ['pacman', 'yay']

    def __init__(self, context):
        super(Yay, self).__init__(self)
        self._context = context
        self._strings = {}
        self._strings[PkgStatus.UP_TO_DATE] = 'is up to date -- skipping'
        self._strings[PkgStatus.INSTALLED] = 'Total Installed Size'
        self._strings[PkgStatus.NOT_FOUND] = 'Could not find all required packages'
        self._strings[PkgStatus.BUILD_FAIL] = 'failed to build'
        self._strings[PkgStatus.ERROR] = 'Errors occurred'

    def can_handle(self, directive):
        return directive in self._directives

    def handle(self, directive, data):
        if not self.can_handle(directive):
            raise ValueError('Yay cannot handle directive %s' % directive)
        if self._bootstrap_yay() != 0:
            raise Exception('Yay could not be installed on your system')
        return self._process_packages(directive, data)

    def _process_packages(self, directive, packages):
        results = {}
        successful = [PkgStatus.UP_TO_DATE, PkgStatus.INSTALLED]

        for pkg in packages:
            result = self._install(pkg)
            results[result] = results.get(result, 0) + 1
            if result not in successful:
                self._log.error('Could not install package {}'.format(pkg))

        if all([result in successful for result in results.keys()]):
            self._log.info('All {} packages installed successfully'.format(directive))
            success = True
        else:
            success = False

        for status, amount in results.items():
            log = self._log.info if status in successful else self._log.error
            log('{} {}'.format(amount, status.value))

        return success

    def _install(self, pkg):
        # Make sure we are sudo so we don't have any problems
        subprocess.call('sudo --validate', shell=True)

        cmd = 'LANG=en_US.UTF-8 yay --needed --noconfirm -S {}'.format(pkg)

        self._log.info('Installing {}'.format(pkg))

        process = subprocess.Popen(cmd, shell=True,
                                   stdout=subprocess.PIPE,
                                   stderr=subprocess.STDOUT)

        out = []

        while True:
            line = process.stdout.readline().decode('utf-8')
            if not line:
                break
            out.append(line)
            self._log.lowinfo(line.strip())
            sys.stdout.flush()

        process.stdout.close()

        out = ''.join(out)

        for status in self._strings.keys():
            if out.find(self._strings[status]) >= 0:
                return status

        self._log.warning('Could not determine what happened with package {}'.format(pkg))
        return PkgStatus.NOT_SURE

    def _bootstrap_yay(self):
        dir_path = os.path.dirname(os.path.realpath(__file__))
        cmd = '{}/bootstrap-yay'.format(dir_path)
        return subprocess.call(cmd, shell=True)
