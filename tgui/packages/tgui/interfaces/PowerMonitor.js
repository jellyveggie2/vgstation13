import { map, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { toFixed } from 'common/math';
import { pureComponentHooks } from 'common/react';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Chart, ColorBox, Flex, Icon, LabeledList, ProgressBar, Section, Table } from '../components';
import { Window } from '../layouts';

export const powerRank = str => {
  const unit = String(str.split(' ')[1]).toLowerCase();
  return ['w', 'kw', 'mw', 'gw'].indexOf(unit);
};

export const PowerMonitor = () => {
  return (
    <Window
      width={550}
      height={700}>
      <Window.Content scrollable>
        <PowerMonitorContent />
      </Window.Content>
    </Window>
  );
};

export const PowerMonitorContent = (props, context) => {
  const { data } = useBackend(context);
  const { history } = data;
  const [
    sortByField,
    setSortByField,
  ] = useLocalState(context, 'sortByField', null);
  const { supply, demand, real, reactive, distorted } = data;
  const supplyNum = history.supply[history.supply.length - 1] || 0;
  const demandNum = history.demand[history.demand.length - 1] || 0;
  const supplyData = history.supply.map((value, i) => [i, value]);
  const demandData = history.demand.map((value, i) => [i, value]);
  const maxValue = Math.max(
    ...history.supply,
    ...history.demand);
    // Process area data


  const realNum = history.real[history.real.length - 1] || 0;
  const reactiveNum = history.reactive[history.reactive.length - 1] || 0;
  const distortedNum = history.distorted[history.distorted.length - 1] || 0;
  const realData = history.real.map((value, i) => [i, value]);
  const reactiveData = history.reactive.map((value, i) => [i, value]);
  const distortedData = history.distorted.map((value, i) => [i, value]);
  const maxValuePQR = Math.max(
    ...history.real,
    ...history.reactive,
    ...history.distorted);

  const areas = flow([
    map((area, i) => ({
      ...area,
      // Generate a unique id
      id: area.name + i,
    })),
    sortByField === 'name' && sortBy(area => area.name),
    sortByField === 'charge' && sortBy(area => -area.charge),
    sortByField === 'draw' && sortBy( area => -area.rawLoad),
    sortByField === 'pf' && sortBy( area => -area.rawPf),
    sortByField === 'thd' && sortBy( area => -area.rawThd),
  ])(data.areas);
  return (
    <>

      <Flex mx={-0.5} mb={1}>

        <Flex.Item mx={0.5} width="200px">
          <Section>
            <LabeledList>
              <LabeledList.Item label="Supply">
                <ProgressBar
                  value={supplyNum}
                  minValue={0}
                  maxValue={demandNum}
                  color="teal">
                  {supply}
                </ProgressBar>
              </LabeledList.Item>
              <LabeledList.Item label="Draw">
                <ProgressBar
                  value={demandNum}
                  minValue={0}
                  maxValue={supplyNum}
                  color="pink">
                  {demand}
                </ProgressBar>
              </LabeledList.Item>
            </LabeledList>
          </Section>
        </Flex.Item>
        <Flex.Item mx={0.5} grow={2}>
          <Box position="relative" height="100%">
            <Chart.Line
              fillPositionedParent
              data={supplyData}
              rangeX={[0, supplyData.length - 1]}
              rangeY={[0, maxValue]}
              strokeColor="rgba(0, 181, 173, 1)"
              fillColor="rgba(0, 181, 173, 0.25)" />
            <Chart.Line
              fillPositionedParent
              data={demandData}
              rangeX={[0, demandData.length - 1]}
              rangeY={[0, maxValue]}
              strokeColor="rgba(224, 57, 151, 1)"
              fillColor="rgba(224, 57, 151, 0.25)" />
          </Box>
        </Flex.Item>
      </Flex>

      <Flex mx={-0.5} mb={1}>
        <Flex.Item mx={0.5} width="200px">
          <Section>
            <LabeledList>
              <LabeledList.Item label="Real">
                <ProgressBar
                  value={realNum}
                  minValue={0}
                  maxValue={demandNum}
                  color="green">
                  {real}
                </ProgressBar>
              </LabeledList.Item>
              <LabeledList.Item label="Reactive">
                <ProgressBar
                  value={reactiveNum}
                  minValue={0}
                  maxValue={demandNum}
                  color="blue">
                  {reactive}
                </ProgressBar>
              </LabeledList.Item>
              <LabeledList.Item label="Distortion">
                <ProgressBar
                  value={distortedNum}
                  minValue={0}
                  maxValue={demandNum}
                  color="red">
                  {distorted}
                </ProgressBar>
              </LabeledList.Item>
            </LabeledList>
          </Section>
        </Flex.Item>

        <Flex.Item mx={0.5} grow={2}>
          <Box position="relative" height="100%">
            <Chart.Line
              fillPositionedParent
              data={realData}
              rangeX={[0, realData.length - 1]}
              rangeY={[0, maxValuePQR]}
              strokeColor="rgba(0, 255, 0, 1)"
              fillColor="rgba(0, 255, 0, 0.1)" />
            <Chart.Line
              fillPositionedParent
              data={reactiveData}
              rangeX={[0, reactiveData.length - 1]}
              rangeY={[0, maxValuePQR]}
              strokeColor="rgba(0, 0, 255, 1)"
              fillColor="rgba(0, 0, 255, 0.1)" />
            <Chart.Line
              fillPositionedParent
              data={distortedData}
              rangeX={[0, distortedData.length - 1]}
              rangeY={[0, maxValuePQR]}
              strokeColor="rgba(255, 0, 0, 1)"
              fillColor="rgba(255, 0, 0, 0.1)" />
          </Box>
        </Flex.Item>
      </Flex>

      <Section>
        <Box mb={1}>
          <Box inline mr={2} color="label">
            Sort by:
          </Box>
          <Button.Checkbox
            checked={sortByField === 'name'}
            content="Name"
            onClick={() => setSortByField(
              sortByField !== 'name' && 'name'
            )} />
          <Button.Checkbox
            checked={sortByField === 'charge'}
            content="Charge"
            onClick={() => setSortByField(
              sortByField !== 'charge' && 'charge'
            )} />
          <Button.Checkbox
            checked={sortByField === 'draw'}
            content="Draw"
            onClick={() => setSortByField(
              sortByField !== 'draw' && 'draw'
            )} />
          <Button.Checkbox
            checked={sortByField === 'pf'}
            content="Power Factor"
            onClick={() => setSortByField(
              sortByField !== 'pf' && 'pf'
            )} />
          <Button.Checkbox
            checked={sortByField === 'draw'}
            content="Total Harmonic Distortion"
            onClick={() => setSortByField(
              sortByField !== 'thd' && 'thd'
            )} />
        </Box>
        <Table>
          <Table.Row header>
            <Table.Cell>
              Area
            </Table.Cell>
            <Table.Cell collapsing>
              Charge
            </Table.Cell>
            <Table.Cell textAlign="right">
              Draw
            </Table.Cell>
            <Table.Cell textAlign="right">
              PF
            </Table.Cell>
            <Table.Cell textAlign="right">
              THD
            </Table.Cell>
            <Table.Cell collapsing title="Equipment">
              Eqp
            </Table.Cell>
            <Table.Cell collapsing title="Lighting">
              Lgt
            </Table.Cell>
            <Table.Cell collapsing title="Environment">
              Env
            </Table.Cell>
          </Table.Row>
          {areas.map((area, i) => (
            <tr
              key={area.id}
              className="Table__row candystripe">
              <td>
                {area.name}
              </td>
              <td className="Table__cell text-right text-nowrap">
                <AreaCharge
                  charging={area.charging}
                  charge={area.charge} />
              </td>
              <td className="Table__cell text-right text-nowrap">
                {area.load}
              </td>
              <td className="Table__cell text-right text-nowrap">
                {area.pf}
              </td>
              <td className="Table__cell text-right text-nowrap">
                {area.thd}
              </td>
              <td className="Table__cell text-center text-nowrap">
                <AreaStatusColorBox status={area.eqp} />
              </td>
              <td className="Table__cell text-center text-nowrap">
                <AreaStatusColorBox status={area.lgt} />
              </td>
              <td className="Table__cell text-center text-nowrap">
                <AreaStatusColorBox status={area.env} />
              </td>
            </tr>
          ))}
        </Table>
      </Section>
    </>
  );
};

export const AreaCharge = props => {
  const { charging, charge } = props;
  return (
    <>
      <Icon
        width="18px"
        textAlign="center"
        name={(
          charging === 0 && (
            charge > 50
              ? 'battery-half'
              : 'battery-quarter'
          )
          || charging === 1 && 'bolt'
          || charging === 2 && 'battery-full'
        )}
        color={(
          charging === 0 && (
            charge > 50
              ? 'yellow'
              : 'red'
          )
          || charging === 1 && 'yellow'
          || charging === 2 && 'green'
        )} />
      <Box
        inline
        width="36px"
        textAlign="right">
        {toFixed(charge) + '%'}
      </Box>
    </>
  );
};

AreaCharge.defaultHooks = pureComponentHooks;

const AreaStatusColorBox = props => {
  const { status } = props;
  const power = Boolean(status & 2);
  const mode = Boolean(status & 1);
  const tooltipText = (power ? 'On' : 'Off')
    + ` [${mode ? 'auto' : 'manual'}]`;
  return (
    <ColorBox
      color={power ? 'good' : 'bad'}
      content={mode ? undefined : 'M'}
      title={tooltipText} />
  );
};

AreaStatusColorBox.defaultHooks = pureComponentHooks;
